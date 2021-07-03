# Network variables

variable "project" {
    description = "This is a prefix given to all resources and tags to identify that they belong to Servian Tech Challenge project"
    type = string
    default = "Servian_TC"
}
variable "environment" {
    description = "Environment for the application such as prod, staging, dev etc."
    type = string
}

variable "aws_vpc_cidr" {
    description = "CIDR range for the VPC"
    type = string
}

variable "public_subnets_cidr" {
    description = "CIDR range for public Subnets"
    type = list(string)
}

variable "private_subnets_cidr" {
    description = "CIDR range for private Subnets"
    type = list(string)
}

variable "availability_zones" {
    description = "Availability Zones"
    type = list(string)
}
