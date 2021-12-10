resource "aws_alb" "servian_alb" {
  name               = "servianalb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id,
  ]
  security_groups = [aws_security_group.servian_alb_security_group.id]
}


resource "aws_lb_target_group" "target_group" {
    name        = "target-group"
    port        = 80
    protocol    = "HTTP"
    target_type = "ip"
    vpc_id      = aws_vpc.servian_vpc.id
    health_check {
        matcher = "200,301,302"
        path = "/healthcheck/"
    }
    lifecycle {
    create_before_destroy = true
    }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_alb.servian_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
