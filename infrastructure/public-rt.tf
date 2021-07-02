# Create a public route table for Public Subnets
 
resource "aws_route_table" "servian_tc_public" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.servian_tc_igw.id
  }
  tags = {
    Name        = "Servian TC Public Route Table"
    Terraform   = "True"
    }
}
 
# Attach a public route table to Public Subnets
 
resource "aws_route_table_association" "servian_tc_public_2a_association" {
  subnet_id = aws_subnet.servian_tc_public_2a.id
  route_table_id = aws_route_table.servian_tc_public.id
}
 
resource "aws_route_table_association" "servian_tc_public_2b_association" {
  subnet_id = aws_subnet.servian_tc_public_2b.id
  route_table_id = aws_route_table.servian_tc_public.id
}