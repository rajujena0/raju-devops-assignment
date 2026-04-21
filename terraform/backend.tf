terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "devops-assignment-tfstate-118688039965"
    key            = "devops-assignment/terraform.tfstate"
    region         = "ap-south-2"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
