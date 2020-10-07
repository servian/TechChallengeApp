terraform {
  backend "local" {}
}

provider "aws" {
  region = "ap-southeast-2"
  version = "~> 2.60"
}

// read the provider information from the aws provider
data "aws_region" "region" {}

# create an s3 bucket to store the state file
resource "aws_s3_bucket" "this" {
  bucket_prefix = format("%s-state-", var.name)
  region = data.aws_region.region.current
  acl = "private"
  versioning {
    enabled = true
  }

  tags = merge(
  {
    "Name" = format("%s-state", var.name)
  },
  var.tags,
  )

}

# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "this" {
  name = format("%s-state-lock", var.name)
  hash_key = "LockID"
  read_capacity = 1
  write_capacity = 1

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = merge(
  {
    "Name" = format("%s-state", var.name)
  },
  var.tags,
  )
}
