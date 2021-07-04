locals {
  prefix = "${var.project}_${var.environment}"
}

# Create Bastion Host Security Group

resource "aws_security_group" "servian_tc_bastion_sg" {
  vpc_id = var.vpc_id
  name   = "${local.prefix}_Bastion_Host_SG"
  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "${local.prefix}_Bastion_SG"
    Terraform   = "True"
    Environment = var.environment
  }
}

# Create Template file data source for DB import

data "template_file" "db_update_template" {
  template = file("${path.module}/user-data/db-update.tpl")
  vars = {
    db_user                 = "${var.db_user}",
    db_password             = "${var.db_port}",
    db_name                 = "${var.db_name}",
    db_port                 = "${var.db_port}",
    db_host                 = "${var.db_host}",
    listen_host             = "${var.listen_host}",
    listen_port             = "${var.listen_port}",
    latest_app_package_path = "${var.latest_app_package_path}"
  }
}

# Create Bastion host in public subnets

resource "aws_instance" "servian_tc_bastion_host" {
  count                       = length(var.public_subnet_ids)
  ami                         = var.bastion_ami
  instance_type               = var.instance_type
  key_name                    = var.aws_key_name
  associate_public_ip_address = var.associate_public_ip_address
  vpc_security_group_ids      = [aws_security_group.servian_tc_bastion_sg.id]
  subnet_id                   = element(var.public_subnet_ids, count.index)
  user_data                   = data.template_file.db_update_template.rendered
  tags = {
    Name        = "${local.prefix}_Bastion_Host"
    Terraform   = "True"
    Environment = var.environment
  }
}


