output "db_address" {
  value       = module.backend.db_address
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value       = module.backend.db_port
  description = "The port the database is listening on"
}

output "db_user" {
  value       = module.backend.db_user
  description = "Master user for the DB"
}

output "db_password" {
  value       = module.backend.db_password
  description = "The password of the master user"
}

output "db_name" {
  value       = module.backend.db_name
  description = "The database name in the DB"
}

