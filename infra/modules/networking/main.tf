
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "vpc-${var.aws_region}-cloudtechchallenge"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_subnet" "public_web" {
  vpc_id = aws_vpc.main.id
  count = length(var.azs)

  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index+1)
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.azs[count.index]}-public-cloudtechchallenge-web"
  }
}

resource "aws_subnet" "private_application" {
  vpc_id = aws_vpc.main.id
  count = length(var.azs)

  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index+length(var.azs)+1)
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.azs[count.index]}-private-cloudtechchallenge-application"
  }
}

resource "aws_subnet" "private_database" {
  vpc_id = aws_vpc.main.id
  count = length(var.azs)

  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index+length(var.azs)*2+1)
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet-${var.azs[count.index]}-private-cloudtechchallenge-application"
  }
}