output "bastion_public_ip" {
  value       = module.bastion.bastion_public_ip
  description = "Public IP address of the bastion hosts"
}

output "bastion_sg_id" {
  value       = module.bastion.bastion_sg_id
  description = "ID of the Bastion host Security group"
}
