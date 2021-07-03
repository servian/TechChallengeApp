output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.servian_tc_vpc.id
}

output "public_subnet_ids" {
  description = "IDs of all public subnets within the VPC "
  value       = aws_subnet.servian_tc_public.*.id
}

output "private_subnet_ids" {
  description = "IDs of all private subnets within the VPC "
  value       = aws_subnet.servian_tc_private.*.id
}
