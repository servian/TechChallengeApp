resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/ecs/techchallenge-app"
  retention_in_days = 3
}
