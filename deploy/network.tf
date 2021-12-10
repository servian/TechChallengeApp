resource "aws_vpc" "servian_vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
}

resource "aws_subnet" "public_a" {
    vpc_id = "${aws_vpc.servian_vpc.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = "${var.aws_region}a"
    map_public_ip_on_launch = true
}

resource "aws_subnet" "public_b" {
    vpc_id = "${aws_vpc.servian_vpc.id}"
    cidr_block = "10.0.2.0/24"
    availability_zone = "${var.aws_region}b"
    map_public_ip_on_launch = true
}

# resource "aws_subnet" "private_a" {
#   count             = 2
#   cidr_block        = cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)
#   availability_zone = data.aws_availability_zones.available_zones.names[count.index]
#   vpc_id            = aws_vpc.default.id
# }


resource "aws_internet_gateway" "internet_gateway" {
    vpc_id = "${aws_vpc.servian_vpc.id}"
}

resource "aws_route" "internet_access" {
    route_table_id = "${aws_vpc.servian_vpc.main_route_table_id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway.id}"
}

resource "aws_security_group" "servian_security_group" {
    name = "servian_security_group"
    description = "Allow TLS inbound traffic on port 80 (http)"
    vpc_id = "${aws_vpc.servian_vpc.id}"

    ingress {
        from_port = 80
        to_port = 3000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_security_group" "servian_alb_security_group" {
    vpc_id = "${aws_vpc.servian_vpc.id}"
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

}

resource "aws_security_group" "postgres_security_group" {
  name = "postgres_security_group"
  vpc_id = aws_vpc.servian_vpc.id

  ingress {
    from_port = 5432 #Check
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "persistent_data" {
  name = "persistent_data"
  description = "Persistent Data"

  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]
}