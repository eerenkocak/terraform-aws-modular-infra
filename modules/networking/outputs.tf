output "vpc_id" {
  description = "Provisioned VPC ID"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "Public DMZ Subnet ID"
  value       = aws_subnet.public.id
}

output "private_app_subnet_id" {
  description = "Private Application Subnet ID"
  value       = aws_subnet.private_app.id
}

output "private_db_subnet_ids" {
  description = "List of isolated Multi-AZ Database Subnet IDs"
  value       = aws_subnet.private_db[*].id
}
