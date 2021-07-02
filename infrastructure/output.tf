output "vpc_id" {
  description = "Custom VPC ID"
  value = aws_vpc.servian_tc_vpc.id
}


output "alb_endpoint" {
  description = "The ALB DNS name to access the application"
  value = aws_lb.servian_tc_alb.dns_name
}