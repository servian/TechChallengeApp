output "db_address" {
  value       = aws_db_instance.servian_tc_db.address
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value       = aws_db_instance.servian_tc_db.port
  description = "The port the database is listening on"
}

output "db_user" {
  value       = aws_db_instance.servian_tc_db.username
  description = "Master user for the DB"
}

output "db_password" {
  value       = aws_db_instance.servian_tc_db.password
  description = "The password of the master user"
}

output "db_name" {
  value       = aws_db_instance.servian_tc_db.name
  description = "The database name in the DB"
}

