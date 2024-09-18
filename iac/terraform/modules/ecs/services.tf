resource "aws_ecs_service" "this" {
  for_each        = var.services

  cluster         = module.ecs.cluster_id
  desired_count   = each.value.desired_count
  launch_type     = "FARGATE"
  name            = "${var.cluster_name}-${each.key}-ecs-service"
  task_definition = aws_ecs_task_definition.this[each.key].arn

  # Deployment
  deployment_controller {
    type = "ECS"

  }

  deployment_circuit_breaker {
    enable   = each.value.deployment_circuit_breaker.enable
    rollback = each.value.deployment_circuit_breaker.rollback
  }

  # Networking
  load_balancer {
    container_name   = each.value.load_balancer.container_name
    container_port   = each.value.load_balancer.container_port
    target_group_arn = each.value.load_balancer.target_group_arn
  }

  # Load Balancer
  network_configuration {
    subnets         = each.value.network_configuration.subnets
    security_groups = each.value.network_configuration.security_groups
  }

  tags = {
    "Service" = "ECS"
    "Name"    = "${var.cluster_name}-${each.key}-service"
  }
}

# #Networking & Security
# # TODO: Refactor to ingress / egress rules
# resource "aws_security_group" "ecs" {
#   name = "${var.project}-${local.environment}-ecs-sg"
#   description = "Allow all traffic to ECS tasks"

#   vpc_id = module.vpc.vpc_id

#   ingress {
#     description = "Allow all TCP traffic in from ALB"

#     from_port   = var.container_port
#     to_port     = var.container_port
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]

#     security_groups = [
#       aws_security_group.alb_sg.id
#     ]
#   }


#   egress {
#     description = "Allow all traffic out"
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     "Service" = "ECS",
#     "Name"    = "${var.project}-${local.environment}-ecs-sg"
#   }
# }
