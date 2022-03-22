resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/ecs/${var.tag_prefix}-app"
  retention_in_days = 3
}
