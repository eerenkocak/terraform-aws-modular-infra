# --- 1. DB SUBNET GROUP (AIR-GAPPED MULTI-AZ) ---
resource "aws_db_subnet_group" "this" {
  name       = "${var.environment}-isolated-db-subnet-group"
  subnet_ids = var.private_db_subnet_ids

  tags = {
    Name = "${var.environment}-isolated-db-subnet-group"
  }
}

# --- 2. ZERO-TRUST DATABASE SECURITY GROUP ---
resource "aws_security_group" "database" {
  name        = "${var.environment}-isolated-db-sg"
  description = "Allow PostgreSQL TCP 5432 exclusively from Private App SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL access strictly from App tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.private_app_sg_id]
  }

  tags = {
    Name = "${var.environment}-isolated-db-sg"
  }
}

# --- 3. MANAGED POSTGRESQL RDS INSTANCE ---
resource "aws_db_instance" "postgres" {
  identifier            = "${var.environment}-core-postgres-db"
  engine                = "postgres"
  engine_version        = "15"
  instance_class        = var.db_instance_class
  allocated_storage     = 20
  max_allocated_storage = 30 # FinOps: Strict autoscaling cap to prevent runaway billing
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "telemetrycore"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.database.id]

  publicly_accessible     = false
  multi_az                = var.multi_az
  backup_retention_period = 7
  skip_final_snapshot     = true
  deletion_protection     = false

  tags = {
    Name = "${var.environment}-core-postgres-rds"
    Tier = "AirGapped-Data"
  }
}
