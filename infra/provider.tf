provider "aws" {
  region = var.aws_region
  assume_role {
    role_arn = "arn:aws:iam::726363461405:role/TerraformDeploymentAccessRole"
  }
}