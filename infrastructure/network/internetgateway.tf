resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_prefix}-gateway"
  }
  #  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "routetable" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.tag_prefix}-route-table"
  }
}

#link between route and Internet Gateway
#complete route configuration 
resource "aws_route" "internetaccess" {
  route_table_id         = aws_route_table.routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

#link between routing table and public subnet
resource "aws_route_table_association" "route_add" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.routetable.id
}

output "gateway" {
  value = aws_internet_gateway.internet_gateway
}
