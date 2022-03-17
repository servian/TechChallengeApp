
resource "aws_security_group" "ecs_security_group" {
  name   = "${var.tag_prefix}-ecs-sg"
  vpc_id = var.vpc_id
  ingress {
    description = "allow tcp 3000"
    protocol    = "tcp"
    from_port   = 3000
    to_port     = 3000
    cidr_blocks = ["0.0.0.0/0"] #could only restrict loadbalancer security group but feeling lazy :) Note: production avoid opening to world
    self        = false
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    self        = false
  }
  tags = {
    Name = "${var.tag_prefix}-security-group"
  }
}
