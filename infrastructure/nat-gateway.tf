# CREATE ELASTIC IP ADDRESS FOR NAT GATEWAY

  resource "aws_eip" "servian_tc_nat1" {
}
  resource "aws_eip" "servian_tc_nat2" {
}
  

# CREATE NAT GATEWAY in ap-southeast-1a

  resource "aws_nat_gateway" "servian_tc_nat_gateway_2a" {
  allocation_id = aws_eip.servian_tc_nat1.id
  subnet_id     = aws_subnet.servian_tc_public_2a.id

  tags = {
    Name        = "Nat Gateway-2a"
    Terraform   = "True"
  }
}

# CREATE NAT GATEWAY in ap-southeast-1b

resource "aws_nat_gateway" "servian_tc_nat_gateway_2b" {
  allocation_id = aws_eip.servian_tc_nat2.id
  subnet_id     = aws_subnet.servian_tc_public_2b.id

  tags = {
    Name        = "Nat Gateway-2b"
    Terraform   = "True"
  }
}