resource "aws_security_group" "app_security_group" {
  name   = "app-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    self             = false
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    self             = false
  }
  tags = {
    Name = "${var.tag_prefix}-securitygroup"
  }
}
