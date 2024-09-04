# Roles
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
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_policy_document.json
}

# Task Policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#Public ECR Policy
# data "aws_iam_policy_document" "ecr_policy_document" {
#   version = "2012-10-17"

#   statement {
#     actions = [
#       "ecr-public:GetDownloadUrlForLayer",
#       "ecr-public:BatchGetImage",
#       "ecr-public:BatchCheckLayerAvailability"
#     ]
#     effect    = "Allow"
#     resources = ["*"]
#   }
# }

# resource "aws_iam_policy" "ecr_policy" {
#   name        = "ecr_policy"
#   description = "Allow ECS to pull images from ECR"
#   policy      = data.aws_iam_policy_document.ecr_policy_document.json
# }

# resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
#   role       = aws_iam_role.ecs_task_execution_role.name
#   policy_arn = aws_iam_policy.ecr_policy.arn
# }
