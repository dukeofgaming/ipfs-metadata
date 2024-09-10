# S3 bucket access policy
resource "aws_iam_policy" "terraform_state_access" {
  name        = "TerraformStateS3AccessPolicy-${var.name}-${var.environment}"
  description = "Policy to allow access to the Terraform state bucket"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${var.backend.s3_bucket_arn}",  # Bucket itself
          "${var.backend.s3_bucket_arn}/*" # All objects in the bucket
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "terraform_state_access_attachment" {
  user       = data.aws_iam_user.this.user_name
  policy_arn = aws_iam_policy.terraform_state_access.arn
}

# DynamoDB access policy
resource "aws_iam_policy" "terraform_state_lock_access" {
  name        = "TerraformStateLockDynamoDBAccessPolicy-${var.name}-${var.environment}"
  description = "Policy to allow access to the Terraform state lock table"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        Resource = var.backend.dynamodb_table_arn
      }
    ]
  })

  tags = {
    Name = "TerraformStateLockDynamoDBAccessPolicy-${var.name}-${var.environment}"
    Service = "Terraform"
  }
}

resource "aws_iam_user_policy_attachment" "terraform_state_lock_access_attachment" {
  user       = data.aws_iam_user.this.user_name
  policy_arn = aws_iam_policy.terraform_state_lock_access.arn
}