output "servian_tech_challenge_app_endpoint" {
  value       = module.frontend.ALB_Endpoint
  description = "Please access the app using this endpoint"
}

output "bastion_public_ip" {
  value       = module.management.bastion_public_ip
  description = "Public IP address of the bastion hosts"
}
