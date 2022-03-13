output "network" {
  value = module.techchallange_network.out_vpc
}
output "dbinstance" {
  value = module.techchallange_database.db_instance
}
output "s3_bucket_name" {
  value = "techchallange"
}
output "tf_state_file" {
  value = "servian/s3/challange.tfstate"
}

output "repository_url" {
  value = module.ecs.repository_url
}
output "dbname" {
  value = module.techchallange_database.dbname
}
output "dbuser" {
  value = module.techchallange_database.dbuser
}