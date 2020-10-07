resource "aws_secretsmanager_secret" "this" {
  count = length(var.application_secrets)
  name_prefix  = "${var.name}-application_secrets-${element(keys(var.application_secrets), count.index)}"
}

resource "aws_secretsmanager_secret_version" "this" {
  count         = length(var.application_secrets)
  secret_id     = element(aws_secretsmanager_secret.this.*.id, count.index)
  secret_string = element(values(var.application_secrets), count.index)
}

locals {

  secrets = zipmap(keys(var.application_secrets), aws_secretsmanager_secret_version.this.*.arn)

  secrets_map = [for secretKey in keys(var.application_secrets) : {
    name      = secretKey
    valueFrom = lookup(local.secrets, secretKey)
  }
  ]


}

