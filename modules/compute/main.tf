# --- 1. DYNAMIC AMAZON LINUX 2023 AMI LOOKUP ---
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# --- 2. ZERO-TRUST SECURITY GROUPS ---
# Tier 1: Public Bastion SG
resource "aws_security_group" "bastion" {
  name        = "${var.environment}-bastion-sg"
  description = "Allow external SSH access to Bastion Jump Host"
  vpc_id      = var.vpc_id

  ingress {
    description = "External SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-bastion-sg"
  }
}

# Tier 2: Private App SG (Accepts SSH exclusively from Bastion SG)
resource "aws_security_group" "private_app" {
  name        = "${var.environment}-private-app-sg"
  description = "Zero-Trust SG allowing internal SSH exclusively from Bastion SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Internal SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    description = "Outbound traffic via NAT Gateway"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-private-app-sg"
  }
}

# --- 3. HARDENED EC2 COMPUTE INSTANCES ---
# Public Bastion Host
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [aws_security_group.bastion.id]

  # FinOps: Prevent unexpected T3 burst billing
  credit_specification {
    cpu_credits = "standard"
  }

  # Security: Enforce IMDSv2 metadata hardening
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-bastion-host"
    Tier = "Public-DMZ"
  }
}

# Private Application Workload
resource "aws_instance" "private_app" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.instance_type
  subnet_id              = var.private_app_subnet_id
  vpc_security_group_ids = [aws_security_group.private_app.id]

  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-private-app"
    Tier = "Private-App"
  }
}
