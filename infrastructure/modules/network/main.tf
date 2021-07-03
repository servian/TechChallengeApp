locals {
  prefix = "${var.project}_${var.environment}"
}

# Create a VPC

resource "aws_vpc" "servian_tc_vpc" {
  cidr_block       = var.aws_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name        = "${local.prefix}_VPC"
    Terrafrom   = "True"
    Environment = "${var.environment}"
  }
}

# Create and attach Internet Gateway

resource "aws_internet_gateway" "servian_tc_igw" {
  vpc_id = aws_vpc.servian_tc_vpc.id
  tags = {
    Name        = "${local.prefix}_IGW"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Create public Subnets

resource "aws_subnet" "servian_tc_public" {
  vpc_id                  = aws_vpc.servian_tc_vpc.id
  count                   = length(var.availability_zones)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    Name        = "${local.prefix}_Public_Subnet"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Create private Subnets

resource "aws_subnet" "servian_tc_private" {
  vpc_id                  = aws_vpc.servian_tc_vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = "false"
  tags = {
    Name        = "${local.prefix}_Private_Subnet"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Create Elastic IP address for NAT Gateway

resource "aws_eip" "servian_tc_nat" {
  count = length(var.availability_zones)
  vpc   = true
  tags = {
    Name        = "${local.prefix}_EIP"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Create NAT Gateway

resource "aws_nat_gateway" "servian_tc_nat_gateway" {
  count         = length(var.public_subnets_cidr)
  allocation_id = element(aws_eip.servian_tc_nat.*.id, count.index)
  subnet_id     = element(aws_subnet.servian_tc_public.*.id, count.index)

  tags = {
    Name        = "${local.prefix}_NG"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Create a public Route Table for public Subnets

resource "aws_route_table" "servian_tc_public" {
  vpc_id = aws_vpc.servian_tc_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.servian_tc_igw.id
  }
  tags = {
    Name        = "${local.prefix}_Public_RT"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

# Attach a public Route Table to public Subnets

resource "aws_route_table_association" "servian_tc_public_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.servian_tc_public.*.id, count.index)
  route_table_id = aws_route_table.servian_tc_public.id

}

# Create a private Route Table and associate it with private Subnets

resource "aws_route_table" "servian_tc_private" {
  count  = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.servian_tc_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.servian_tc_nat_gateway.*.id, count.index)
  }
  tags = {
    Name        = "${local.prefix}_Private_RT"
    Terraform   = "True"
    Environment = "${var.environment}"
  }
}

resource "aws_route_table_association" "servian_tc_private_association" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.servian_tc_private.*.id, count.index)
  route_table_id = element(aws_route_table.servian_tc_private.*.id, count.index)
}

