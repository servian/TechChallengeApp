module "bastion" {
  source                      = "../../../modules/services/bastion"
  vpc_id                      = var.vpc_id
  bastion_ami                 = var.bastion_ami
  instance_type               = var.instance_type
  db_user                     = var.db_user
  db_password                 = var.db_password
  db_port                     = var.db_port
  db_name                     = var.db_name
  db_host                     = var.db_host
  listen_host                 = var.listen_host
  listen_port                 = var.listen_port
  latest_app_package_path     = var.latest_app_package_path
  aws_key_name                = var.aws_key_name
  public_subnet_ids           = var.public_subnet_ids
  associate_public_ip_address = var.associate_public_ip_address
  environment                 = var.environment
}
