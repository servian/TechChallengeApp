resource "aws_alb" "app_loadbalancer" {
  name               = "${var.tag_prefix}-loadbalancer"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id,
  ]
  internal        = false
  security_groups = [aws_security_group.loadbalancer_security_group.id]
  tags = {
    Name = "${var.tag_prefix}-loadbalancer"
  }
}

resource "aws_lb_target_group" "loadbalancer_targetgroup" {
  name        = "loadbalancer-targetgroup"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    path = "/healthcheck/"
  }
  tags = {
    Name = "${var.tag_prefix}-loadbalancer"
  }
}

resource "aws_lb_listener" "loadbalancer_listener" {
  load_balancer_arn = aws_alb.app_loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loadbalancer_targetgroup.arn
  }
    tags = {
    Name = "${var.tag_prefix}-loadbalancer"
  }
}
