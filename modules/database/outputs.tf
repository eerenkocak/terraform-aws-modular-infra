output "db_endpoint" {
  description = "Internal DNS endpoint of the isolated PostgreSQL RDS instance"
  value       = aws_db_instance.postgres.endpoint
}
