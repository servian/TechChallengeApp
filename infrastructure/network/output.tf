output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "private_subnet_a_id" {
  value = aws_subnet.private_subnet_a.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_subnet_b.id
}

output "securitygroup_id" {
  value = aws_security_group.app_security_group.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}

output "dbinstance" {
  value = module.techchallange_database.db_instance
}

output "dbname" {
  value = module.techchallange_database.dbname
}

output "dbuser" {
  value = module.techchallange_database.dbuser
}
