# Roles

## Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole-${local.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_policy_document.json
}
## Assume Policy
data "aws_iam_policy_document" "ecs_tasks_assume_policy_document" {
  version = "2012-10-17"

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

## Policy Attachment - Managed AmazonECSTaskExecutionRolePolicy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

## Secrets Manager Policy
resource "aws_iam_policy" "ecs_secrets_policy" {
  name = "ecs-secrets-access-policy-${local.environment}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "secretsmanager:GetSecretValue"
        ],
        Effect   = "Allow",
        Resource = aws_secretsmanager_secret.rds_master_password.arn
      }
    ]
  })
}
# Policy Attachment - Secrets Manager Policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_secrets_policy.arn
}
