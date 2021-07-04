output "ALB_id" {
  value       = module.frontend.ALB_id
  description = "ID fo the ALB which points to ASG instances"
}

output "ALB_Endpoint" {
  value       = module.frontend.ALB_endpoint
  description = "ALB endpoint to access the Servian Tech Challenge App"
}

output "alb_sg_id" {
  value       = module.frontend.alb_sg_id
  description = "ID of the ALB Security group"
}

output "asg_sg_id" {
  value       = module.frontend.asg_sg_id
  description = "ID of the ASG Security group"
}

