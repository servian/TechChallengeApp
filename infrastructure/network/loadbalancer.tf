resource "aws_alb" "app_loadbalancer" {
  name               = "techchallengelb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_b.id,
  ]
  security_groups = [aws_security_group.security_group.id]
}

resource "aws_lb_target_group" "loadbalancer_targetgroup" {
  name        = "targetgroup"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.vpc.id
  health_check {
    matcher = "200"
    path    = "/healthcheck/"
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
}