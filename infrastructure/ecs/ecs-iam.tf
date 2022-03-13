resource "aws_iam_role" "ecstaskexecution_role" {
  name               = "taskexecution"
  assume_role_policy = data.aws_iam_policy_document.policy_role.json
}

data "aws_iam_policy_document" "policy_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecstaskexecution_policy" {
  role       = aws_iam_role.ecstaskexecution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}