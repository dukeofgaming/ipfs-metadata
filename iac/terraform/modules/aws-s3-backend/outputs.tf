output "bucket" {
  description = "The S3 bucket used for storing Terraform state"
  value       = aws_s3_bucket.terraform_state
}

output "lock_table" {
  description = "The DynamoDB table used for locking"
  value       = aws_dynamodb_table.terraform_locks
}