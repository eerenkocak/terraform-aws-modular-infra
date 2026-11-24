variable "environment" {
  description = "Deployment environment name (e.g., dev, prod)"
  type        = string
}

variable "vpc_id" {
  description = "Target VPC ID from networking module"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet ID for Bastion host"
  type        = string
}

variable "private_app_subnet_id" {
  description = "Private subnet ID for backend workload"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type constrained by FinOps guardrails"
  type        = string
  default     = "t3.micro"

  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type)
    error_message = "FinOps Guardrail: Only t3.micro or t3.small instances are permitted."
  }
}

variable "root_volume_size" {
  description = "Root EBS gp3 volume size in GB"
  type        = number
  default     = 10

  validation {
    condition     = var.root_volume_size >= 8 && var.root_volume_size <= 20
    error_message = "FinOps Guardrail: Root volume size must be between 8GB and 20GB."
  }
}
