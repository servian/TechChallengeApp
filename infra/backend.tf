terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket = "central-infra-tfstate"
    key    = "cloudchallenge/cloudchallenge.tfstate"
    region = "ap-southeast-2"
    assume_role = {
      role_arn = "arn:aws:iam::331791526767:role/TerraformStateS3AccessRole",
    }
    encrypt = true
  }
}