output "address" {
  value       = aws_db_instance.servian_tc_db.address
  description = "Connect to the database at this endpoint"
}
output "port" {
  value       = aws_db_instance.servian_tc_db.port
  description = "The port the database is listening on"
}