variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-2"
}

variable "project" {
  description = "Project name used for resource naming"
  type        = string
  default     = "devops-assignment"
}

variable "env" {
  description = "Environment name"
  type        = string
  default     = "staging"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  description = "EC2 instance type — t3.micro for free tier"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS instance class — db.t3.micro for free tier"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "PostgreSQL master username"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "PostgreSQL master password — never hardcoded"
  type        = string
  sensitive   = true
}
