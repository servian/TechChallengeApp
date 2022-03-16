module "techchallange_network" {
  source           = "./network"
  TF_DBSUBNETGROUP = var.TF_DBSUBNETGROUP #value passed from env variables
  tag_prefix       = var.tag_prefix
  AWS_REGION=var.AWS_REGION
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