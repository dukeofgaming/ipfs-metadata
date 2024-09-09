variable "name" {
  description = "The base name of the S3 bucket and DynamoDB table"
  type        = string
}

variable "bucket_name" {
  description = "The name of the S3 bucket to store the Terraform state file"
  type        = string
  default     = "s3-bucket"
}

variable "lock_table_name" {
  description = "The name of the DynamoDB table to store the Terraform state lock"
  type        = string
  default     = "dynamodb-lock-table"
}

variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-2"
}