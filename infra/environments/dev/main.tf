terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    required_version = ">= 0.12"
}

provider "aws" {
    region = "us-east-1"
    profile = "terraform"
}

resource "aws_s3_bucket" "gym_assets_dev" {
    bucket = "gym-assets-dev"

    tags = {
        Project = "POC-GYM-LOG-APP"
        Environment = "dev"
    }
}

# Retrieve the rds password from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "rds_password" {
    secret_id = "dev/poc-gym-log-app/rds"
}

resource "aws_security_group" "rds" {
  name        = "dev-rds-sg"
  description = "Allow inbound Postgres traffic from trusted sources"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "dev-rds-sg"
    Project = "POC-GYM-LOG-APP"
    Environment = "dev"
  }
}

resource "aws_vpc_security_group_ingress_rule" "rds_inbound_0" {
  security_group_id = aws_security_group.rds.id
    from_port         = 5432
    to_port           = 5432
    ip_protocol          = "tcp"
    cidr_ipv4 = module.vpc.private_subnet_cidrs[0]
    description       = "Allow inbound Postgres traffic from trusted sources"
    tags = {
        Name = "dev-rds-sg-ingress"
        Project = "POC-GYM-LOG-APP"
        Environment = "dev"
    }
}

resource "aws_vpc_security_group_ingress_rule" "rds_inbound_1" {
  security_group_id = aws_security_group.rds.id
    from_port         = 5432
    to_port           = 5432
    ip_protocol          = "tcp"
    cidr_ipv4 = module.vpc.private_subnet_cidrs[1]
    description       = "Allow inbound Postgres traffic from trusted sources"
    tags = {
        Name = "dev-rds-sg-ingress"
        Project = "POC-GYM-LOG-APP"
        Environment = "dev"
    }
}

resource "aws_vpc_security_group_egress_rule" "rds_outbound_0" {
    security_group_id = aws_security_group.rds.id
    cidr_ipv4 = module.vpc.private_subnet_cidrs[0]
    from_port         = 0
    to_port           = 0
    ip_protocol       = "tcp"
    description       = "Allow outbound traffic to private subnet"
    tags = {
        Name = "dev-rds-sg-egress"
        Project = "POC-GYM-LOG-APP"
        Environment = "dev"
    }
}

resource "aws_vpc_security_group_egress_rule" "rds_outbound_1" {
    security_group_id = aws_security_group.rds.id
    cidr_ipv4 = module.vpc.private_subnet_cidrs[1]
    from_port         = 0
    to_port           = 0
    ip_protocol       = "tcp"
    description       = "Allow outbound traffic to private subnet"
    tags = {
        Name = "dev-rds-sg-egress"
        Project = "POC-GYM-LOG-APP"
        Environment = "dev"
    }
}

module "rds" {
  source = "../../modules/rds"

  name                = "dev"
  db_name             = "gym_log"
  db_username         = "gym_admin"
  db_password         = jsondecode(data.aws_secretsmanager_secret_version.rds_password.secret_string).rds_password
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [aws_security_group.rds.id]  # You’ll need to define this SG
}

module "vpc" {
  source = "../../modules/vpc"

  name                 = "gym-app-dev"
  vpc_cidr             = "10.0.0.0/20"  # ~4096 IPs total
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}
