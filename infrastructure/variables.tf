# Region

variable "aws_region" {
  type= string
  default="ap-southeast-2"
}

# Define VPC Variable

variable "aws_vpc_cidr" {
  type= string
  default="10.0.0.0/16"
}

variable "servian_tc_bastion_ami" {
  type = string
  default = "ami-05064bb33b40c33a2"
  description = "Amazon Linux 2 AMI for the bastion host in ap-southeast-2 region"  
}

variable "db_master_password" {
  type = string
  default = "postgres"
  description = "Password for the Postgre master user"
}

variable "tech_challenge_app_latest_release" {
  type = string
  default = "https://github.com/servian/TechChallengeApp/releases/download/v.0.8.0/TechChallengeApp_v.0.8.0_linux64.zip"
  description = "TechChallenge apps latest package for Linux"
}
