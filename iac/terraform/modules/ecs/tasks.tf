resource "aws_ecs_task_definition" "this" {
  for_each = var.services

  family = "family-of-${var.cluster_name}-${each.key}-tasks"

  # Resources
  cpu    = each.value.task_definition.cpu
  memory = each.value.task_definition.memory

  requires_compatibilities = each.value.task_definition.requires_compatibilities

  # IAM
  execution_role_arn    = each.value.task_definition.execution_role_arn
  task_role_arn         = each.value.task_definition.task_role_arn


  # Networking
  network_mode = each.value.task_definition.network_mode

  # Containers
  container_definitions = each.value.task_definition.container_definitions

  tags = {
    "Service" = "ECS"
    "Name"    = "${var.cluster_name}-${each.key}-ecs-task"
  }
}

