output "ALB_id" {
  description = "ALB ID created"
  value       = aws_lb.servian_tc_alb.id
}

output "ALB_endpoint" {
  description = "ALB endpoints"
  value       = aws_lb.servian_tc_alb.dns_name
}

