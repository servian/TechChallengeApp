locals {
  prefix = "${var.project}_${var.environment}"
}

# Create Application Load Balancer Security Group
# It allows port 80 for public access and outbound traffic

resource "aws_security_group" "servian_tc_alb_sg" {
  vpc_id = var.vpc_id
  name   = "${local.prefix}_ALB_SG"
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "${local.prefix}_ALB_SG"
    Terraform   = "True"
    Environment = var.environment
  }
}

# Create Application Load Balancer

resource "aws_lb" "servian_tc_alb" {
  name                       = "servian-tc-${var.environment}-frontend-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.servian_tc_alb_sg.id]
  subnets                    = var.alb_subnets_ids
  enable_deletion_protection = var.enable_deletion_protection
  tags = {
    Name        = "${local.prefix}_ALB"
    Terraform   = "True"
    Environment = var.environment
  }
}

# Create Frontend Target Group

resource "aws_lb_target_group" "servian_tc_frontend_tg" {
  port     = var.listen_port
  protocol = "HTTP"
  name     = "servian-tc-${var.environment}frontend-tg"
  vpc_id   = var.vpc_id
  stickiness {
    type    = "lb_cookie"
    enabled = var.stickiness_enabled
  }
  health_check {
    protocol            = var.health_check_protocol
    path                = var.health_check_path
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_check_timeout
    interval            = var.health_check_interval
  }
  tags = {
    Name        = "${local.prefix}_Frontend_TG"
    Terraform   = "True"
    Environment = var.environment
  }
}



# Create ALB Listner - HTTP

resource "aws_lb_listener" "servian_http" {
  load_balancer_arn = aws_lb.servian_tc_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.servian_tc_frontend_tg.arn
  }
}

# Create ALB Listner default Rule - HTTP

resource "aws_lb_listener_rule" "servian_tc_http" {
  listener_arn = aws_lb_listener.servian_http.arn
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.servian_tc_frontend_tg.arn
  }
  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

# Create Security Group for ASG
# It allows ALB to access app listener port 
resource "aws_security_group" "servian_tc_asg_sg" {
  vpc_id = var.vpc_id
  name   = "${local.prefix}_ASG_SG"

  ingress {
    from_port       = var.listen_port
    to_port         = var.listen_port
    protocol        = "tcp"
    security_groups = [aws_security_group.servian_tc_alb_sg.id]
  }

  tags = {
    Name        = "${local.prefix}_ASG_SG"
    Terraform   = "True"
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "egress" {
  description       = "Allow all egress traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.servian_tc_asg_sg.id
}

# Template File Data Source

# TODO: Can be kept outside this file, as bastion also uses this
data "template_file" "userdata_template" {
  template = file("${path.module}/user-data/user-data.tpl")
  vars = {
    db_user                 = "${var.db_user}",
    db_password             = "${var.db_password}",
    db_name                 = "${var.db_name}",
    db_port                 = "${var.db_port}",
    db_host                 = "${var.db_host}",
    listen_host             = "${var.listen_host}",
    listen_port             = "${var.listen_port}",
    latest_app_package_path = "${var.latest_app_package_path}"
  }
}

# Create Launch Configuration

resource "aws_launch_configuration" "servian_tc_launch_config" {
  name_prefix     = "${local.prefix}_Launch_Configuration"
  image_id        = var.app_ami
  instance_type   = var.app_instance_type
  security_groups = [aws_security_group.servian_tc_asg_sg.id]
  key_name        = var.aws_key_name
  user_data       = data.template_file.userdata_template.rendered
  lifecycle {
    create_before_destroy = true
  }
}

# Create Servian TC FrontEnd ASG

resource "aws_autoscaling_group" "servian_tc_frontend" {
  name                 = "${local.prefix}_FrontEnd_ASG"
  launch_configuration = aws_launch_configuration.servian_tc_launch_config.name
  health_check_type    = var.asg_health_check_type
  min_size             = var.asg_min_size
  max_size             = var.asg_max_size
  desired_capacity     = var.asg_desired_capacity

  vpc_zone_identifier = var.asg_subnet_ids
  target_group_arns   = [aws_lb_target_group.servian_tc_frontend_tg.arn]
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "${local.prefix}_ASG"
    propagate_at_launch = true
  }

}

# Create an Autoscaling policy for Auto scaling group

resource "aws_autoscaling_policy" "servian_tc_asg_policy" {
  name                   = "${local.prefix}_autoscaling_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.servian_tc_frontend.name
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }
}


