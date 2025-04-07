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

resource "aws_s3_bucket" "gym_assets" {
    bucket = "gym-assets-dev"

    tags = {
        Project = "POC-GYM-LOG-APP"
        Environment = "dev"
    }
}