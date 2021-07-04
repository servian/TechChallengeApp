output "ALB_id" {
  description = "ALB ID created"
  value       = aws_lb.servian_tc_alb.id
}

output "ALB_endpoint" {
  description = "ALB endpoints"
  value       = aws_lb.servian_tc_alb.dns_name
}

output "alb_sg_id" {
  value       = aws_security_group.servian_tc_alb_sg.id
  description = "ID of the ALB Security group"
}

output "asg_sg_id" {
  value       = aws_security_group.servian_tc_asg_sg.id
  description = "ID of the ASG Security group"
}
