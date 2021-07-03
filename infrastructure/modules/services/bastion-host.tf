# Create Bastion Host Security Group

resource "aws_security_group" "servian_tc_bastion_sg" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  name = "Servian TC Bastion Host SG"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "Servian TC Bastion SG"
    Terraform   = "True"
    } 
}

# CREATE TEMPLATE FILE DATA SOURCE FOR DB IMPORT

data "template_file" "db_update_template" {
  template = file("user-data/db-update.tpl")
  vars = {
    db_user     = "${aws_db_instance.servian_tc_db.username}"
    db_password = "postgres"
    db_name     = "${aws_db_instance.servian_tc_db.name}"
    db_port     = "${aws_db_instance.servian_tc_db.port}",
    db_host     = "${aws_db_instance.servian_tc_db.address}",
    listen_host = "0.0.0.0",
    listen_port = "3000",
    latest_app_package_path = "https://github.com/servian/TechChallengeApp/releases/download/v.0.8.0/TechChallengeApp_v.0.8.0_linux64.zip"
  }
}

# CREATE BASTION HOST IN AP-SOUTHEAST-2A PUBLIC SUBNET

resource "aws_instance" "servian_tc_bastion_host_2a" {
  ami = var.servian_tc_bastion_ami
  instance_type = "t2.micro"
  key_name = aws_key_pair.ssh-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.servian_tc_bastion_sg.id]
  subnet_id = aws_subnet.servian_tc_public_2a.id
  user_data       = data.template_file.db_update_template.rendered
  tags = {
    Name = "Servian TC Bastion Host - 2A"
    Terraform = "True"
  }
}

# CREATE BASTION HOST IN AP-AOUTHEAST-1B PUBLIC SUBNET

# resource "aws_instance" "servian_tc_bastion_host-2b" {
#   ami = var.servian_tc_bastion_ami
#   instance_type = "t2.micro"
#   key_name = aws_key_pair.ssh-key.key_name
#   associate_public_ip_address = true
#   vpc_security_group_ids = [aws_security_group.servian_tc_bastion_sg.id]
#   subnet_id = aws_subnet.servian_tc_public_2b.id
#   tags = {
#     Name = "Servian TC Bastion Host - 2B"
#     Terraform = "True"
#   }
# }