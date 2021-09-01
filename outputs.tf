# VPC
output "vpc_id" {
  description   = "The ID of the VPC"
  value         = module.techchallenge-vpc.vpc_id
}

# Public subnet
output "public_subnets" {
  description   = "List of IDs of public subnets"
  value         = module.techchallenge-vpc.public_subnets
}

# Database subnet
output "database_subnets" {
  description   = "List of IDs of public subnets"
  value         = module.techchallenge-vpc.database_subnets
}