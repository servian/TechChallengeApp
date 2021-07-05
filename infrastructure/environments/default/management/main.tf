module "bastion" {
  source                      = "../../../modules/services/bastion"
  vpc_id                      = var.vpc_id
  bastion_ami                 = var.bastion_ami
  instance_type               = var.instance_type
  aws_key_name                = var.aws_key_name
  public_subnet_ids           = var.public_subnet_ids
  associate_public_ip_address = var.associate_public_ip_address
  environment                 = var.environment
}
