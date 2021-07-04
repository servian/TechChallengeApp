# Create a key pair to associate with EC2 instances
resource "tls_private_key" "servian_tc_admin_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "servian_tc_generated_key" {
  key_name   = var.aws_key_name
  public_key = tls_private_key.servian_tc_admin_key.public_key_openssh
}

module "network" {
  source      = "./network"
  environment = var.environment
}

module "backend" {
  source             = "./backend"
  environment        = var.environment
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  name = var.db_name
  db_user                 = var.db_user
  db_password             = var.db_password
}

module "frontend" {
  source                  = "./frontend"
  environment             = var.environment
  vpc_id                  = module.network.vpc_id
  asg_subnet_ids          = module.network.private_subnet_ids
  alb_subnets_ids         = module.network.public_subnet_ids
  db_user                 = var.db_user
  db_password             = var.db_password
  db_port                 = module.backend.db_port
  db_name                 = var.db_name
  db_host                 = module.backend.db_address
  latest_app_package_path = var.app_package_link
  listen_port             = var.app_port
  app_ami                 = var.ami
  aws_key_name            = aws_key_pair.servian_tc_generated_key.key_name
}

module "management" {
  source                  = "./management"
  environment             = var.environment
  vpc_id                  = module.network.vpc_id
  public_subnet_ids       = module.network.public_subnet_ids
  # db_user                 = var.db_user
  # db_password             = var.db_password
  # db_port                 = module.backend.db_port
  # db_name                 = var.db_name
  # db_host                 = module.backend.db_address
  # latest_app_package_path = var.app_package_link
  # listen_port             = var.app_port
  bastion_ami             = var.ami
  aws_key_name            = aws_key_pair.servian_tc_generated_key.key_name
  depends_on              = [module.backend, module.frontend]

}

# Define the Security Group rules here once all the resources are created to avoid cyclic dependencies

locals {
  backend_allowed_sg = [module.frontend.asg_sg_id, module.management.bastion_sg_id]
}

# Create Security Group ingress rules for backend Security group
# Allows ASG SG & Bastion SG to access DB port
resource "aws_security_group_rule" "servian_tc_backend_sg_rule" {
  count     = length(local.backend_allowed_sg)
  type      = "ingress"
  from_port = module.backend.db_port
  to_port   = module.backend.db_port
  protocol  = "tcp"
  # cidr_blocks = var.allowed_security_groups
  source_security_group_id = element(local.backend_allowed_sg, count.index)
  security_group_id        = module.backend.backend_sg_id
}

# Allow bastion hosts to SSH into app hosting private ec2 hosts
resource "aws_security_group_rule" "servian_tc_asg_rule" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.management.bastion_sg_id
  security_group_id        = module.frontend.asg_sg_id
}
