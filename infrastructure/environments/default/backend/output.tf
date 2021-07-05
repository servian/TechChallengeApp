output "db_address" {
  value       = module.backend.db_address
  description = "Connect to the database at this endpoint"
}

output "db_port" {
  value       = module.backend.db_port
  description = "The port the database is listening on"
}

output "db_password" {
  value       = module.backend.db_password
  description = "DB master password"
  sensitive = true
}

output "backend_sg_id" {
  value       = module.backend.backend_sg_id
  description = "Backend Security Group id"
}
