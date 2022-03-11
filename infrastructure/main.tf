module "techchallange_network" {
  source           = "./network"
  TF_DBSUBNETGROUP = var.TF_DBSUBNETGROUP #value passed from env variables
  tag_prefix       = var.tag_prefix
}

module "techchallange_database" {
  source           = "./database"
  tag_prefix       = var.tag_prefix
  TF_DBUSER       = var.TF_DBUSER       #value passed from env variables
  TF_DBPASSWORD    = var.TF_DBPASSWORD    #value passed from env variables
  TF_DBSUBNETGROUP = var.TF_DBSUBNETGROUP #value passed from env variables
  depends_on = [
    module.techchallange_network
  ]
}
output "network" {
  value = module.techchallange_network.out_vpc
}

output "dbinstance" {
  value = module.techchallange_database.db_instance
}

