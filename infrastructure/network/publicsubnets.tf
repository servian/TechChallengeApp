resource "aws_subnet" "public_subnet_a" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "172.16.20.0/24"
  availability_zone = "ap-southeast-2a"
  tags = {
    Name = "${var.tag_prefix}-public-a"
  }
}