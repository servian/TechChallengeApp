# Create Security Group for ASG

resource "aws_security_group" "servian_tc_asg_sg" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  name = "Servian TC ASG SG"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
#  ingress {
#     from_port = 80
#     to_port = 80
#     protocol = "tcp"
#     security_groups = [
#       aws_security_group.servian_tc_alb_sg.id
#     ]
#   }
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    security_groups = [
      aws_security_group.servian_tc_alb_sg.id
    ]
  }
  ingress {
    from_port   = 22
    to_port     = 22
     
    protocol    = "tcp"
    security_groups = [
      aws_security_group.servian_tc_bastion_sg.id
    ]
    # protocol    = "tcp"
    # cidr_blocks = [
    #   "0.0.0.0/0"
    # ]
  }
  tags = {
    Name        = "Servian TC ASG SG"
    Terraform   = "True"
  } 
}

# Template File Data Source
 
# TODO: Can be kept outside this file, as bastion also uses this
data "template_file" "userdata_template" {
  template = file("user-data/user-data.tpl")
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

# Create Launch Configuration

resource "aws_launch_configuration" "servian_tc_launch_config" {
  name_prefix     = "Servian TC Launch Configuration"
  image_id        = var.servian_tc_bastion_ami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.servian_tc_asg_sg.id]
  # key_name        = aws_key_pair.ssh-key.key_name
  user_data       = data.template_file.userdata_template.rendered
  lifecycle {
    create_before_destroy = true
  }
}

# Create Servian TC FrontEnd ASG

resource "aws_autoscaling_group" "servian_tc_frontend" {
  name                 = "Servian TC FrontEnd ASG"
  launch_configuration = aws_launch_configuration.servian_tc_launch_config.name
  health_check_type    = "ELB"
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1

  vpc_zone_identifier = [
    aws_subnet.servian_tc_private_2a.id,
    aws_subnet.servian_tc_private_2b.id
  ]
  target_group_arns = [aws_lb_target_group.servian_tc_frontend_tg.arn]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "Servian TC FrontEnd ASG"
    propagate_at_launch = true  
  }
}


