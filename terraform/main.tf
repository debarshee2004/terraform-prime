terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      Owner       = var.owner
      CreatedBy   = "terraform"
    }
  }
}

# Networking Layer (VPC, Subnets, Security Groups)
module "networking" {
  source = "./modules/networking"
  
  project_name        = var.project_name
  environment         = var.environment
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets
  database_subnets   = var.database_subnets
}

# Security Layer (IAM, KMS, Security Groups)
module "security" {
  source = "./modules/security"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
}

# Database Layer (RDS, ElastiCache, DynamoDB)
module "database" {
  source = "./modules/database"
  
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.networking.vpc_id
  database_subnets   = module.networking.database_subnets
  database_sg_id     = module.security.database_sg_id
  db_instance_class  = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
}

# Compute Layer (ALB, ASG, ECS)
module "compute" {
  source = "./modules/compute"
  
  project_name         = var.project_name
  environment          = var.environment
  vpc_id               = module.networking.vpc_id
  public_subnets       = module.networking.public_subnets
  private_subnets      = module.networking.private_subnets
  alb_sg_id            = module.security.alb_sg_id
  ecs_sg_id            = module.security.ecs_sg_id
  ecs_task_role_arn    = module.security.ecs_task_role_arn
  ecs_execution_role_arn = module.security.ecs_execution_role_arn
  instance_type        = var.instance_type
  min_size             = var.min_size
  max_size             = var.max_size
  desired_capacity     = var.desired_capacity
}

# Storage Layer (S3, CloudFront)
module "storage" {
  source = "./modules/storage"
  
  project_name = var.project_name
  environment  = var.environment
  alb_dns_name = module.compute.alb_dns_name
  alb_zone_id  = module.compute.alb_zone_id
}