# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet-group"
  subnet_ids = var.database_subnets
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet-group"
  }
}

# RDS Parameter Group
resource "aws_db_parameter_group" "main" {
  family = "mysql8.0"
  name   = "${var.project_name}-${var.environment}-db-params"
  
  parameter {
    name  = "innodb_buffer_pool_size"
    value = "{DBInstanceClassMemory*3/4}"
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-db-params"
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-db"
  
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp2"
  storage_encrypted = true
  
  db_name  = "streamingapp"
  username = "admin"
  password = "changeme123!" # In production, use AWS Secrets Manager
  
  vpc_security_group_ids = [var.database_sg_id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  parameter_group_name   = aws_db_parameter_group.main.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = {
    Name = "${var.project_name}-${var.environment}-database"
  }
}

# ElastiCache Subnet Group
resource "aws_elasticache_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-cache-subnet-group"
  subnet_ids = var.database_subnets
  
  tags = {
    Name = "${var.project_name}-${var.environment}-cache-subnet-group"
  }
}

# ElastiCache Redis Cluster
resource "aws_elasticache_replication_group" "main" {
  replication_group_id       = "${var.project_name}-${var.environment}-cache"
  description                = "Redis cluster for ${var.project_name}-${var.environment}"
  
  node_type                  = "cache.t3.micro"
  port                       = 6379
  parameter_group_name       = "default.redis7"
  
  num_cache_clusters         = 2
  automatic_failover_enabled = true
  multi_az_enabled          = true
  
  subnet_group_name = aws_elasticache_subnet_group.main.name
  security_group_ids = [var.database_sg_id]
  
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  
  tags = {
    Name = "${var.project_name}-${var.environment}-cache"
  }
}

# DynamoDB Table for user sessions
resource "aws_dynamodb_table" "user_sessions" {
  name           = "${var.project_name}-${var.environment}-user-sessions"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user_id"
  range_key      = "session_id"
  
  attribute {
    name = "user_id"
    type = "S"
  }
  
  attribute {
    name = "session_id"
    type = "S"
  }
  
  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }
  
  server_side_encryption {
    enabled = true
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-user-sessions"
  }
}

# DynamoDB Table for content metadata
resource "aws_dynamodb_table" "content_metadata" {
  name           = "${var.project_name}-${var.environment}-content-metadata"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "content_id"
  
  attribute {
    name = "content_id"
    type = "S"
  }
  
  attribute {
    name = "category"
    type = "S"
  }
  
  attribute {
    name = "created_at"
    type = "N"
  }
  
  global_secondary_index {
    name     = "category-created-index"
    hash_key = "category"
    range_key = "created_at"
    projection_type = "ALL"
  }
  
  server_side_encryption {
    enabled = true
  }
  
  tags = {
    Name = "${var.project_name}-${var.environment}-content-metadata"
  }
}
