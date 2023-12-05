output "vpc_id" {
  value = aws_vpc.main.id 
}

output "web_subnet_ids" {
  value = aws_subnet.public_web[*].id
}

output "application_subnet_ids" {
  value = aws_subnet.private_application[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.private_database[*].id
}