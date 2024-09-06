resource "aws_ecs_service" "this" {
  cluster         = module.ecs.cluster_id
  desired_count   = 1             #TODO: Look at autoscaling
  launch_type     = "FARGATE"
  name            = "${var.project}-${local.environment}-ecs-service"
  task_definition = resource.aws_ecs_task_definition.this.arn

  #TODO: Parameterize these
  # Restart policy
  health_check_grace_period_seconds   = 300 
  deployment_minimum_healthy_percent  = 50
  deployment_maximum_percent          = 100

  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = true         # Enables the circuit breaker
    rollback = true        # Automatically roll back on failure
  }

  # Networking
  load_balancer {
    container_name   = local.container_name
    container_port   = var.container_port
    target_group_arn = module.alb.target_group_arns[0]
  }

  # Load Balancer
  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [
      aws_security_group.ecs.id
    ]
  }

  lifecycle {
    ignore_changes = [desired_count] # Allow external changes to happen without Terraform conflicts, particularly around auto-scaling.
  }

  tags = {
    "Service" = "ECS"
    "Name"    = "${var.project}-${local.environment}-ecs-service"
  }
}

#Networking & Security

resource "aws_security_group" "ecs" {
  name        = "${var.project}-${local.environment}-ecs-sg"
  description = "ECS Service Security Group"

  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow all TCP traffic in from ALB"

    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_groups = [
      module.alb.security_group_id,
    ]
  }


  egress {
    description = "Allow all traffic out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Service" = "ECS",
    "Name"    = "${var.project}-${local.environment}-ecs-sg"
  }
}
