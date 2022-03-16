resource "aws_subnet" "private_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.4.0/24"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "${var.tag_prefix}-private-a"
  }
}

resource "aws_subnet" "private_subnet_b" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.0.0/24"
  availability_zone = "ap-southeast-2b"
  tags = {
    Name = "${var.tag_prefix}-private-b"
  }
}

resource "aws_db_subnet_group" "dbsubnetgroup" {
  name       = var.TF_DBSUBNETGROUP
  subnet_ids = [aws_subnet.private_subnet_a.id, aws_subnet.private_subnet_b.id]
  tags = {
    Name = "${var.tag_prefix}-subnetgroup"
  }
}

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.20.0/24"
  availability_zone       = "ap-southeast-2a"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.tag_prefix}-public-a"
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "172.16.3.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-2b"
  tags = {
    Name = "${var.tag_prefix}-public-b"
  }
}
