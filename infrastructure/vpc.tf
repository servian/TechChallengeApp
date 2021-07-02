# Create VPC

resource "aws_vpc" "servian_tc_vpc" {
  cidr_block = var.aws_vpc_cidr
  instance_tenancy = "default"
  tags = {
    Name = "Servian TC VPC"
    Terrafrom = "True"
  }
}