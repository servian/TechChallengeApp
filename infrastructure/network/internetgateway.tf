resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_prefix}-gateway"
  }
  #  depends_on = [aws_internet_gateway.gw]
}

output "gateway" {
  value = aws_internet_gateway.internet_gateway
}