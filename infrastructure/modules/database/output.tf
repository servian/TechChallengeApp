output "db_address" {
  value       = aws_db_instance.servian_tc_db.address
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value       = aws_db_instance.servian_tc_db.port
  description = "The port the database is listening on"
}

output "backend_sg_id" {
  value       = aws_security_group.servian_tc_backend_sg.id
  description = "Backend Security Group id"
}

