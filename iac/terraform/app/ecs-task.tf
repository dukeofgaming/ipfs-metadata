locals {
  container_environment = {
    "POSTGRES_HOST"     = aws_db_instance.database.endpoint
    "POSTGRES_USER"     = local.database_username
    "POSTGRES_DB"       = local.database_name
    "POSTGRES_PASSWORD" = var.database_password
    "POSTGRES_PORT"     = var.database_port
  }
}

resource "aws_ecs_task_definition" "this" {
  container_definitions = jsonencode(
    [
      {
        environment : toset([
          for key, value in local.container_environment : {
            name  = key
            value = value
          }
        ]),

        essential = true,
        image     = var.container_image,
        name      = local.container_name,

        portMappings = [
          {
            containerPort = var.container_port,
            hostPort      = var.container_port
          }
        ],

        logConfiguration = {
          logDriver = "awslogs",
          options = {
            awslogs-group         = aws_cloudwatch_log_group.ecs_log_group.name,
            awslogs-region        = var.aws_region,
            awslogs-stream-prefix = "ecs"
          }
        },
      }
    ]
  )

  cpu    = 256
  memory = 512

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  family = "family-of-${var.project}-${local.environment}-tasks"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  depends_on = [
    aws_db_instance.database,
    module.ecr
  ]
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project}-${local.environment}-logs"
  retention_in_days = 7 # Set retention policy for log data
}