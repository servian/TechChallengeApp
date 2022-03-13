resource "aws_ecr_repository" "ecr_repo" {
  name                 = "techchallenge"
  image_tag_mutability = "MUTABLE"

  tags = {
    Name = "${var.tag_prefix}-ecr-repo"
  }
}

output "repository_url" {
  value = aws_ecr_repository.ecr_repo.repository_url
}
