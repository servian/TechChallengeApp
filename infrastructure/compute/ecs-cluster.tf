resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.tag_prefix}-cluster"
}
