# Create Frontend Target Group

resource "aws_lb_target_group" "servian_tc_frontend_tg" {
  port = 3000
  protocol = "HTTP"
  name = "servian-tc-frontend-tg"
  vpc_id = aws_vpc.servian_tc_vpc.id
  stickiness {
    type = "lb_cookie"
    enabled = true
  }
  health_check {
    protocol = "HTTP"
    path = "/healthcheck/"
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 5
    interval = 10
  }
  tags = {
    Name        = "Servian TC Front End TG"
    Terraform   = "True"   
  } 
}
