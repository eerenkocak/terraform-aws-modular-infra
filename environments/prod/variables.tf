variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidr" {
  type = string
}

variable "private_app_subnet_cidr" {
  type = string
}

variable "private_db_subnet_cidrs" {
  type = list(string)
}

variable "db_password" {
  type      = string
  sensitive = true
}
