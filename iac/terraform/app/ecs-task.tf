locals {

  split_database_host_port = split(":", aws_db_instance.database.endpoint)

  # Environment overrides
  container_environment = coalesce(
    var.container_environment,
    {
      "POSTGRES_HOST"     = local.split_database_host_port[0]
      "POSTGRES_USER"     = local.database_username
      "POSTGRES_DB"       = local.database_name
      # "POSTGRES_PASSWORD" = var.database_password               #TODO: Replace with AWS Secrets Manager
      "POSTGRES_PORT"     = local.split_database_host_port[1]
      "VERSION"           = var.version
    }
  )
}

# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/secrets-envvar-secrets-manager.html
resource "aws_ecs_task_definition" "this" {

  family = "family-of-${var.project}-${local.environment}-tasks"

  # Resources
  cpu    = 256
  memory = 512

  requires_compatibilities = ["FARGATE"]

  # IAM
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  #TODO: See if task role is needed for RDS


  # Networking
  network_mode = "awsvpc"

  # Containers
  container_definitions = jsonencode(
    [
      {
        name : local.container_name,
        essential : true,

        # Container configuration
        image : var.container_image,
        portMappings : [
          {
            containerPort : var.container_port,
            hostPort : var.container_port
          }
        ],

        environment : toset([
          for key, value in local.container_environment : {
            name : key
            value : value
          }
        ]),

        secrets: [{
          name      : "POSTGRES_PASSWORD",
          valueFrom : aws_secretsmanager_secret.rds_master_password.arn
        }]

        # AWS Integrations
        logConfiguration : {
          logDriver : "awslogs",
          options : {
            awslogs-group : aws_cloudwatch_log_group.ecs_log_group.name,
            awslogs-region : var.aws_region,
            awslogs-stream-prefix : "ecs"
          }
        },
      }
    ]
  )

  depends_on = [
    aws_db_instance.database, # Database should exist before ECS task
  ]

  tags = {
    "Service" = "ECS"
    "Name"    = "${var.project}-${local.environment}-ecs-task"
  }
}

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project}-${local.environment}-logs"
  retention_in_days = 7
}