resource "aws_security_group" "loadbalancer_security_group" {
  name   = "${var.tag_prefix}-loadbalancer-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    description = "allow tcp 80"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
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
