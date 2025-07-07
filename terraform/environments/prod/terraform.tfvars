aws_region = "us-west-2"
project_name = "streaming-app"
environment = "prod"
owner = "prod-team"

vpc_cidr = "10.2.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
public_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
private_subnets = ["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24"]
database_subnets = ["10.2.21.0/24", "10.2.22.0/24", "10.2.23.0/24"]

db_instance_class = "db.r5.large"
db_allocated_storage = 100

instance_type = "c5.large"
min_size = 3
max_size = 20
desired_capacity = 6