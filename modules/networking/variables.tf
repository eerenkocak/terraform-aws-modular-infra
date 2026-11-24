variable "environment" {
  description = "Deployment environment name (e.g., dev, prod)"
  type        = string
}

variable "aws_region" {
  description = "Target AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for Public DMZ subnet"
  type        = string
}

variable "private_app_subnet_cidr" {
  description = "CIDR block for Private Application subnet"
  type        = string
}

variable "private_db_subnet_cidrs" {
  description = "List of CIDR blocks for Multi-AZ isolated Database subnets"
  type        = list(string)
}
