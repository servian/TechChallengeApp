# Create first private route table and associate it with private subnet

resource "aws_route_table" "servian_tc_private_2a" {
    vpc_id = aws_vpc.servian_tc_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.servian_tc_nat_gateway_2a.id
  }
    tags =  {
        Name      = "Servian TC Private 2A"
        Terraform = "True"
  }
}
 
resource "aws_route_table_association" "servian_tc_private_2a_association" {
    subnet_id = aws_subnet.servian_tc_private_2a.id
    route_table_id = aws_route_table.servian_tc_private_2a.id
}
 
# Create second private route table and associate it with private subnet
 
resource "aws_route_table" "servian_tc_private_2b" {
    vpc_id = aws_vpc.servian_tc_vpc.id
    route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.servian_tc_nat_gateway_2b.id
  }
    tags =  {
        Name      = "Servian TC Private 2B"
        Terraform = "True"
  }
}
 
resource "aws_route_table_association" "servian_tc_private_2b_association" {
    subnet_id = aws_subnet.servian_tc_private_2b.id
    route_table_id = aws_route_table.servian_tc_private_2b.id
}
