output "state_bucket" {
  value = aws_s3_bucket.this.bucket
}

output "lock_table" {
  value = aws_dynamodb_table.this.name
}