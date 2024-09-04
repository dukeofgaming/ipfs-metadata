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
        name      = local.container_name,

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