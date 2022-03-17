resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.tag_prefix
  image_tag_mutability = "MUTABLE"
  tags = {
    Name = "${var.tag_prefix}-ecr-repo"
  }
}
