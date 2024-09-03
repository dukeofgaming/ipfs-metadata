output "bucket" {
  value = aws_s3_bucket.terraform_state
}

output "lock_table" {
  value = aws_dynamodb_table.terraform_locks
}