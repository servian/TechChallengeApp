output "vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_vpc.this.*.id, [""])[0]
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = concat(aws_vpc.this.*.arn, [""])[0]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = concat(aws_vpc.this.*.default_security_group_id, [""])[0]
}

output "default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = concat(aws_vpc.this.*.default_network_acl_id, [""])[0]
}

output "default_route_table_id" {
  description = "The ID of the default route table"
  value       = concat(aws_vpc.this.*.default_route_table_id, [""])[0]
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = concat(aws_vpc.this.*.instance_tenancy, [""])[0]
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = concat(aws_vpc.this.*.enable_dns_support, [""])[0]
}

output "vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = concat(aws_vpc.this.*.enable_dns_hostnames, [""])[0]
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = concat(aws_vpc.this.*.main_route_table_id, [""])[0]
}

output "vpc_ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block"
  value       = concat(aws_vpc.this.*.ipv6_association_id, [""])[0]
}

output "vpc_ipv6_cidr_block" {
  description = "The IPv6 CIDR block"
  value       = concat(aws_vpc.this.*.ipv6_cidr_block, [""])[0]
}

output "vpc_secondary_cidr_blocks" {
  description = "List of secondary CIDR blocks of the VPC"
  value       = aws_vpc_ipv4_cidr_block_association.this.*.cidr_block
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC"
  value       = concat(aws_vpc.this.*.owner_id, [""])[0]
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private.*.id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private.*.arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private.*.cidr_block
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public.*.id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public.*.arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public.*.cidr_block
}

output "database_subnets" {
  description = "List of IDs of database subnets"
  value       = aws_subnet.database.*.id
}

output "database_subnet_arns" {
  description = "List of ARNs of database subnets"
  value       = aws_subnet.database.*.arn
}

output "database_subnets_cidr_blocks" {
  description = "List of cidr_blocks of database subnets"
  value       = aws_subnet.database.*.cidr_block
}

output "database_subnet_group" {
  description = "ID of database subnet group"
  value       = concat(aws_db_subnet_group.database.*.id, [""])[0]
}

output "public_route_table_ids" {
  description = "List of IDs of public route tables"
  value       = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  description = "List of IDs of private route tables"
  value       = aws_route_table.private.*.id
}

output "database_route_table_ids" {
  description = "List of IDs of database route tables"
  value       = length(aws_route_table.database.*.id) > 0 ? aws_route_table.database.*.id : aws_route_table.private.*.id
}

output "public_internet_gateway_route_id" {
  description = "ID of the internet gateway route."
  value       = concat(aws_route.public_internet_gateway.*.id, [""])[0]
}

output "database_nat_gateway_route_ids" {
  description = "List of IDs of the database nat gateway route."
  value       = aws_route.database_nat_gateway.*.id
}

output "private_nat_gateway_route_ids" {
  description = "List of IDs of the private nat gateway route."
  value       = aws_route.private_nat_gateway.*.id
}

output "private_route_table_association_ids" {
  description = "List of IDs of the private route table association"
  value       = aws_route_table_association.private.*.id
}

output "database_route_table_association_ids" {
  description = "List of IDs of the database route table association"
  value       = aws_route_table_association.database.*.id
}

output "public_route_table_association_ids" {
  description = "List of IDs of the public route table association"
  value       = aws_route_table_association.public.*.id
}

output "nat_ids" {
  description = "List of allocation ID of Elastic IPs created for AWS NAT Gateway"
  value       = aws_eip.nat.*.id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = var.reuse_nat_ips ? var.external_nat_ips : aws_eip.nat.*.public_ip
}

output "natgw_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this.*.id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = concat(aws_internet_gateway.this.*.id, [""])[0]
}

output "igw_arn" {
  description = "The ARN of the Internet Gateway"
  value       = concat(aws_internet_gateway.this.*.arn, [""])[0]
}

output "default_vpc_id" {
  description = "The ID of the VPC"
  value       = concat(aws_default_vpc.this.*.id, [""])[0]
}

output "default_vpc_arn" {
  description = "The ARN of the VPC"
  value       = concat(aws_default_vpc.this.*.arn, [""])[0]
}

output "default_vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_default_vpc.this.*.cidr_block, [""])[0]
}

output "default_vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = concat(aws_default_vpc.this.*.default_security_group_id, [""])[0]
}

output "default_vpc_default_network_acl_id" {
  description = "The ID of the default network ACL"
  value       = concat(aws_default_vpc.this.*.default_network_acl_id, [""])[0]
}

output "default_vpc_default_route_table_id" {
  description = "The ID of the default route table"
  value       = concat(aws_default_vpc.this.*.default_route_table_id, [""])[0]
}

output "default_vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC"
  value       = concat(aws_default_vpc.this.*.instance_tenancy, [""])[0]
}

output "default_vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = concat(aws_default_vpc.this.*.enable_dns_support, [""])[0]
}

output "default_vpc_enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  value       = concat(aws_default_vpc.this.*.enable_dns_hostnames, [""])[0]
}

output "default_vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC"
  value       = concat(aws_default_vpc.this.*.main_route_table_id, [""])[0]
}

output "public_network_acl_id" {
  description = "ID of the public network ACL"
  value       = concat(aws_network_acl.public.*.id, [""])[0]
}

output "public_network_acl_arn" {
  description = "ARN of the public network ACL"
  value       = concat(aws_network_acl.public.*.arn, [""])[0]
}

output "private_network_acl_id" {
  description = "ID of the private network ACL"
  value       = concat(aws_network_acl.private.*.id, [""])[0]
}

output "private_network_acl_arn" {
  description = "ARN of the private network ACL"
  value       = concat(aws_network_acl.private.*.arn, [""])[0]
}

output "database_network_acl_id" {
  description = "ID of the database network ACL"
  value       = concat(aws_network_acl.database.*.id, [""])[0]
}

output "database_network_acl_arn" {
  description = "ARN of the database network ACL"
  value       = concat(aws_network_acl.database.*.arn, [""])[0]
}


# Static values (arguments)
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = var.azs
}

output "name" {
  description = "The name of the VPC specified as argument to this module"
  value       = var.name
}
