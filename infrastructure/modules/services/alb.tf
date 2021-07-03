# Create Application Load Balancer Security Group

resource "aws_security_group" "servian_tc_alb_sg" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  name = "Servian TC ALB SG"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
  tags = {
    Name        = "Servian TC ALB SG"
    Terraform   = "True"   
  } 
}

# Create Application Load Balancer

resource "aws_lb" "servian_tc_alb" {
  name               = "servian-tc-frontend-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.servian_tc_alb_sg.id]
  subnets = [
    aws_subnet.servian_tc_public_2a.id,
    aws_subnet.servian_tc_public_2b.id,
  ]
  enable_deletion_protection = false
  tags = {
    Name        = "Servian TC ALB"
    Terraform   = "True"   
  } 
}