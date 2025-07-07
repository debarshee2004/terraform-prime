terraform {
  required_version = ">= 1.0"
  
  # Uncomment and configure for remote state
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "streaming-app/prod/terraform.tfstate"
  #   region = "us-west-2"
  # }
}

module "streaming_app" {
  source = "../../"
  
  aws_region           = var.aws_region
  project_name         = var.project_name
  environment          = var.environment
  owner               = var.owner
  vpc_cidr            = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnets      = var.public_subnets
  private_subnets     = var.private_subnets
  database_subnets    = var.database_subnets
  db_instance_class   = var.db_instance_class
  db_allocated_storage = var.db_allocated_storage
  instance_type       = var.instance_type
  min_size            = var.min_size
  max_size            = var.max_size
  desired_capacity    = var.desired_capacity
}