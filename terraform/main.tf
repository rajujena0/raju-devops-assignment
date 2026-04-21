provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project
      Environment = var.env
      ManagedBy   = "Terraform"
    }
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}
