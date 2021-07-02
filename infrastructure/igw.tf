# Create and Attach internet gateway

resource "aws_internet_gateway" "servian_tc_igw" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  tags = {
    Name        = "Servian TC Internet Gateway"
    Terraform   = "True"
  }
}