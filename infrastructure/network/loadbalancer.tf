resource "aws_alb" "app_loadbalancer" {
  name               = "techchallenge-loadbalancer"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id,    
  ]
  internal           = false
  security_groups = [aws_security_group.loadbalancer_security_group.id]
  tags = {
    Name = "${var.tag_prefix}-loadbalancer"
  }
}
