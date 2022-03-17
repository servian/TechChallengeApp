module "techchallange_network" {
  source           = "./network"
  TF_DBSUBNETGROUP = var.TF_DBSUBNETGROUP #value passed from env variables
  tag_prefix       = var.tag_prefix
  AWS_REGION       = var.AWS_REGION
}

module "techchallange_database" {
  source           = "./database"
  tag_prefix       = var.tag_prefix
  TF_DBUSER        = var.TF_DBUSER        #value passed from env variables
  TF_DBPASSWORD    = var.TF_DBPASSWORD    #value passed from env variables
  TF_DBSUBNETGROUP = var.TF_DBSUBNETGROUP #value passed from env variables
  securitygroup_id = module.techchallange_network.securitygroup_id
  vpc_id           = module.techchallange_network.vpc_id
  depends_on = [
    module.techchallange_network
  ]
}


module "compute" {
  source              = "./compute"
  tag_prefix          = var.tag_prefix
  private_subnet_a_id = module.techchallange_network.private_subnet_a_id
  private_subnet_b_id = module.techchallange_network.private_subnet_b_id
  vpc_id              = module.techchallange_network.vpc_id
  loadbalancer_tg_arn = module.techchallange_network.loadbalancer_tg_arn
  depends_on = [
    module.techchallange_network
  ]
}

#update conf.toml 
resource "local_file" "ConfigFile" {
  content  = <<EOT
"DbUser"="${var.TF_DBUSER}"
"DbPassword"="${var.TF_DBPASSWORD}"
"DbName"="${module.techchallange_database.dbname}"
"DbPort"="5432"
"DbHost"="${module.techchallange_database.db_instance}"
"ListenHost"="0.0.0.0"
"ListenPort"="3000"
EOT 
  filename = "./conf.toml"
}

#update ecr_repourl.conf
resource "local_file" "ecr_repourl" {
  content  = module.compute.repository_url
  filename = "./ecr_repourl.conf"
}
