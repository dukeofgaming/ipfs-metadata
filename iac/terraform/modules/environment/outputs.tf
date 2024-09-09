output "name" {
  value = var.environment_name
}

output "s3_backend" {
  description = "The S3 backend configuration"
  value       = module.s3_backend
}

output "accounts" {
  description = "A map of the account names to their IAM user object"
  value       = aws_iam_user.environment_accounts
}
