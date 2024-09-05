resource "aws_ecs_service" "this" {
  cluster         = module.ecs.cluster_id
  desired_count   = 1
  launch_type     = "FARGATE"
  name            = "${var.project}-${local.environment}-ecs-service"
  task_definition = resource.aws_ecs_task_definition.this.arn

  lifecycle {
    ignore_changes = [desired_count] # Allow external changes to happen without Terraform conflicts, particularly around auto-scaling.
  }

  load_balancer {
    container_name   = local.container_name
    container_port   = var.container_port
    target_group_arn = module.alb.target_group_arns[0]
  }

  network_configuration {
    security_groups = [
      module.vpc.default_security_group_id
    ]
    subnets = module.vpc.private_subnets
  }
}

resource "aws_security_group_rule" "allow_alb_to_ecs" {
  type                     = "ingress"
  from_port                = var.container_port
  to_port                  = var.container_port
  protocol                 = "tcp"
  source_security_group_id = module.alb.security_group_id
  security_group_id        = module.vpc.default_security_group_id
}