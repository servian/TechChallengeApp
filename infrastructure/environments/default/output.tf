output "vpc_id" {
  value = module.network.vpc_id
}

output "bastion_public_ip" {
  value       = module.management.bastion_public_ip
  description = "Public IP address of the bastion hosts"
}

output "app_endpoint" {
  value       = module.frontend.ALB_Endpoint
  description = "Please access the app using this endpoint"
}
