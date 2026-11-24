output "bastion_public_ip" {
  description = "Public IP address of the Bastion Host"
  value       = aws_instance.bastion.public_ip
}

output "private_app_ip" {
  description = "Private IP address of the Application instance"
  value       = aws_instance.private_app.private_ip
}

output "private_app_sg_id" {
  description = "Security Group ID of the Private App tier for downstream database isolation"
  value       = aws_security_group.private_app.id
}
