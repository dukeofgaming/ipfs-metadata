# data "aws_iam_role" "ecs_task_execution_role" {
#   name = "ecsTaskExecutionRole" 
# }

# Task IAM
data "aws_iam_policy_document" "ecs_tasks_policy_document" {
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
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_policy_document.json
}
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_task_execution_role.name
}

#ECS IAM
resource "aws_iam_policy" "ecs_task_execution_policy" {
  name = "ecs_task_execution_policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability"
        ],
        "Resource": "*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode(
    [
      {
        environment : [
          {
            name  = "FOO",
            value = "BAR"
          }
        ],

        essential = true,
        image     = var.container_image,
        name      = "${var.project}-${local.environment}-nginx",

        portMappings = [
          {
            containerPort = var.container_port,
            hostPort      = var.container_port
          }
        ],
      }
    ]
  )

  cpu    = 256
  memory = 512

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  family = "family-of-${var.project}-${local.environment}-tasks"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
}