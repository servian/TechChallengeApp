output "private_subnet_a_id" {
  value = aws_subnet.private_subnet_a.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_subnet_b.id
}
output "out_vpc" {
  value = aws_vpc.vpc
}
output "securitygroup_id" {
  value = aws_security_group.security_group.id
}
output "loadbalancer_arn" {
  value = aws_lb_target_group.loadbalancer_targetgroup.arn
}