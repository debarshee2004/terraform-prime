aws_region = "us-west-2"
project_name = "streaming-app"
environment = "staging"
owner = "staging-team"

vpc_cidr = "10.1.0.0/16"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
public_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnets = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]
database_subnets = ["10.1.21.0/24", "10.1.22.0/24", "10.1.23.0/24"]

db_instance_class = "db.t3.small"
db_allocated_storage = 50

instance_type = "t3.medium"
min_size = 2
max_size = 8
desired_capacity = 3