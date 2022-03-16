 output "db_instance" {
  value = aws_db_instance.postgres_instance.address
}

output "dbuser" {
  value = aws_db_instance.postgres_instance.username
}

output "dbname" {
  value = aws_db_instance.postgres_instance.name
}

output "postgres_securitygroup_id" {
  value=aws_security_group.postgres_securitygroup.id
}
