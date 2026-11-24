terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "eren-devops-tf-state-2026"
    key            = "environments/prod/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform-Modules"
    }
  }
}

module "networking" {
  source = "../../modules/networking"

  environment             = "prod"
  aws_region              = var.aws_region
  vpc_cidr                = var.vpc_cidr
  public_subnet_cidr      = var.public_subnet_cidr
  private_app_subnet_cidr = var.private_app_subnet_cidr
  private_db_subnet_cidrs = var.private_db_subnet_cidrs
}

module "compute" {
  source = "../../modules/compute"

  environment           = "prod"
  vpc_id                = module.networking.vpc_id
  public_subnet_id      = module.networking.public_subnet_id
  private_app_subnet_id = module.networking.private_app_subnet_id
  instance_type         = "t3.small"
  root_volume_size      = 20
}

module "database" {
  source = "../../modules/database"

  environment           = "prod"
  vpc_id                = module.networking.vpc_id
  private_db_subnet_ids = module.networking.private_db_subnet_ids
  private_app_sg_id     = module.compute.private_app_sg_id
  db_instance_class     = "db.t3.micro"
  db_password           = var.db_password
  multi_az              = true
}
