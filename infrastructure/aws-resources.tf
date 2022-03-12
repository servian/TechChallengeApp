terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket         = "techchallange"
    key            = "servian/s3/challange.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "techchallenge-dynamodb-table"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.AWS_REGION
}
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "techchallenge-dynamodb-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
