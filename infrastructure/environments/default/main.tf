module "networking" {
  source = "../../modules/network"
  environment = var.environment
  aws_vpc_cidr = var.aws_vpc_cidr
  public_subnets_cidr = var.public_subnets_cidr
  private_subnets_cidr = var.private_subnets_cidr
  availability_zones = var.availability_zones
}
