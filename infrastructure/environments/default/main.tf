module "network" {
  source      = "./network"
  environment = var.environment
}

module "backend" {
  source             = "./backend"
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids

}

module "frontend" {
  source          = "./frontend"
  environment     = var.environment
  vpc_id          = module.network.vpc_id
  asg_subnet_ids  = module.network.private_subnet_ids
  alb_subnets_ids = module.network.public_subnet_ids
  db_user         = module.backend.db_user
  db_password     = module.backend.db_password
  db_port         = module.backend.db_port
  db_name         = module.backend.db_name
  db_host         = module.backend.db_address

}

module "management" {
  source            = "./management"
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  db_user           = module.backend.db_user
  db_password       = module.backend.db_password
  db_port           = module.backend.db_port
  db_name           = module.backend.db_name
  db_host           = module.backend.db_address
  key_name          = ""
  depends_on        = [module.backend]

}
