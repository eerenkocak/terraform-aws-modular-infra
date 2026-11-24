output "prod_bastion_ip" {
  value = module.compute.bastion_public_ip
}

output "prod_db_endpoint" {
  value = module.database.db_endpoint
}
