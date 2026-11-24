output "dev_bastion_ip" {
  value = module.compute.bastion_public_ip
}

output "dev_db_endpoint" {
  value = module.database.db_endpoint
}
