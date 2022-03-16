terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    #provider is needed to generate files from terraform
    local = {
      source = "hashicorp/local"
    }
  }

  #remote state setup - create and provide bucket
  backend "s3" {
    bucket         = "techchallange"
    key            = "servian/s3/challange.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "apptechc-statelocktable"
  }
}

provider "aws" {
  region = var.AWS_REGION
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.tag_prefix}-statelocktable"  
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  
  tags = {
    Name = "${var.tag_prefix}-dynamo"
  }
}
 