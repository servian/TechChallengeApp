resource "aws_ecr_repository" "ecr_repo" {
    name = "ecr_servian"
}

data "aws_ecr_repository" "ecr_repo" {
  name = "ecr_servian"
  depends_on = [
    aws_ecr_repository.ecr_repo
  ]
}
