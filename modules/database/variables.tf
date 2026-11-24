variable "environment" {
  description = "Deployment environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "Target VPC ID from networking module"
  type        = string
}

variable "private_db_subnet_ids" {
  description = "List of isolated Multi-AZ subnet IDs for DB Subnet Group"
  type        = list(string)
}

variable "private_app_sg_id" {
  description = "Security Group ID of the Private App tier allowed to query DB"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance size constrained by FinOps policies"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "Master administrator username for PostgreSQL"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Master password for PostgreSQL instance"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ high availability deployment"
  type        = bool
  default     = false
}
