output "ALB_id" {
  value       = module.frontend.ALB_id
  description = "ID fo the ALB which points to ASG instances"
}

output "ALB_Endpoint" {
  value       = module.frontend.ALB_endpoint
  description = "ALB endpoint to access the Servian Tech Challenge App"
}
