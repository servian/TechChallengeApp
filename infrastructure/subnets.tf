# Create Public Subnets

resource "aws_subnet" "servian_tc_public_2a" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "Servian TC Public Subnet - 2A"
    Terraform   = "True"
  }
}
resource "aws_subnet" "servian_tc_public_2b" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-southeast-2b"
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "Servian TC Public Subnet - 2B"
    Terraform   = "True"
  }
}


# Create Private Subnets


resource "aws_subnet" "servian_tc_private_2a" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-southeast-2a"
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "Servian TC Private Subnet - 2a"
    Terraform   = "True"
  }
}

resource "aws_subnet" "servian_tc_private_2b" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "ap-southeast-2b"
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "Servian TC Private Subnet - 2B"
    Terraform   = "True"
  }
}