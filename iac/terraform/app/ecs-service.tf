resource "aws_ecs_service" "this" {
  cluster         = module.ecs.cluster_id
  desired_count   = 1
  launch_type     = "FARGATE"
  name            = "${var.project}-${local.environment}-ecs-service"
  task_definition = resource.aws_ecs_task_definition.this.arn

  # Deployment
  deployment_controller {
    type = "ECS"
  }

  deployment_circuit_breaker {
    enable   = var.ecs_circuit_breaker.enable
    rollback = var.ecs_circuit_breaker.rollback
  }

  # Networking
  load_balancer {
    container_name   = local.container_name
    container_port   = var.container_port
    target_group_arn = aws_lb_target_group.app.arn
  }

  # Load Balancer
  network_configuration {
    subnets         = module.vpc.private_subnets
    security_groups = [
      aws_security_group.ecs.id
    ]
  }

  tags = {
    "Service" = "ECS"
    "Name"    = "${var.project}-${local.environment}-ecs-service"
  }
}

#Networking & Security

resource "aws_security_group" "ecs" {
  description = "Allow all traffic to ECS tasks"

  vpc_id = module.vpc.vpc_id

  ingress {
    description = "Allow all TCP traffic in from ALB"

    from_port   = var.container_port
    to_port     = var.container_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }


  egress {
    description = "Allow all traffic out"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    "Service" = "ECS",
    "Name"    = "${var.project}-${local.environment}-ecs-sg"
  }
}
