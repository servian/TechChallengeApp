module "network" {
  source      = "./network"
  environment = var.environment
}

module "backend" {
  source             = "./backend"
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnets

}
