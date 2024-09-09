module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.2.1"

  repository_force_delete = true
  repository_name         = var.ecr_repository_name

  repository_image_tag_mutability = "MUTABLE"

  repository_lifecycle_policy = jsonencode({
    rules = [{
      action = {
        type = "expire"
      }
      description  = "Delete all images except a handful of the newest images"
      rulePriority = 1
      selection = {
        countNumber = 3
        countType   = "imageCountMoreThan"
        tagStatus   = "any"
      }
    }]
  })

}

#IAM for pipeline account
resource "aws_iam_policy" "pipeline_push_ecr" {
  name        = "ECRPushPolicy-${var.name}-${var.environment}"
  description = "Policy to allow pushing to ECR repository"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action : [
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
        ]
        Effect : "Allow"
        Resource : module.ecr.repository_arn
      },
      {
        Effect : "Allow",
        Action : "ecr:GetAuthorizationToken",
        Resource : "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "ecr_push_policy_attachment" {
  user       = data.aws_iam_user.this.user_name
  policy_arn = aws_iam_policy.pipeline_push_ecr.arn
}