resource "aws_eip" "eip_nat_gateway_a" {
  vpc = true
  tags = {
    Name = "${var.tag_prefix}-eip-natgateway"
  }
}

resource "aws_nat_gateway" "nat_gateway_a" {
  allocation_id = aws_eip.eip_nat_gateway_a.id
  subnet_id     = aws_subnet.public_subnet_a.id
  tags = {
    Name = "${var.tag_prefix}-natgateway_a"
  }
}

resource "aws_route_table" "private_route_table_a" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway_a.id
  }

  tags = {
    Name = "${var.tag_prefix}-privateroutetable_b"
  }
}

resource "aws_route_table_association" "table_a_private_subnet_a_association" {
  subnet_id      = aws_subnet.private_subnet_a.id
  route_table_id = aws_route_table.private_route_table_a.id
}

resource "aws_route_table_association" "table_a_private_subnet_b_association" {
  subnet_id      = aws_subnet.private_subnet_b.id
  route_table_id = aws_route_table.private_route_table_a.id
}
