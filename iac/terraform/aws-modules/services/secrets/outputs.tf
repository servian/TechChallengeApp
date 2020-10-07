output "application_secrets_arns" {
  value = aws_secretsmanager_secret_version.this.*.arn
}

output "secrets_map" {
  value = local.secrets_map
}