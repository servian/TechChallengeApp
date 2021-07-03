# Create ALB Listner - HTTP

resource "aws_lb_listener" "servian_http" {
  load_balancer_arn = aws_lb.servian_tc_alb.arn
  port = 80
  protocol = "HTTP"
   
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.servian_tc_frontend_tg.arn
  }
}

# Create ALB Listner default Rule - HTTP

# resource "aws_lb_listener_rule" "servian_tc_http" {
#   listener_arn = aws_lb_listener.servian_tc_http.arn
#   priority     = 100
#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.servian_tc_frontend_tg.arn
#   }
#     condition {
#     path_pattern {
#       values = ["/"]
#     }
#   }
# }