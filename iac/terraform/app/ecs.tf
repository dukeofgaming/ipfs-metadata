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
      "VERSION"           = var.app_version
    }
  )
}

module "ecs" {
  source = "../modules/ecs"

  cluster_name = "${var.project}-${local.environment}-ecs-cluster"

  services = {
    "ipfs-metadata" = {
      desired_count = 1

      deployment_circuit_breaker = {
        enable   = var.ecs_circuit_breaker.enable
        rollback = var.ecs_circuit_breaker.rollback
      }

      load_balancer = {
        container_name   = local.container_name
        container_port   = var.container_port
        target_group_arn = aws_lb_target_group.app.arn
      }

      network_configuration = {
        subnets = module.vpc.private_subnets
        security_groups = [
          aws_security_group.ecs.id
        ]
      }

      task_definition = {
        execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

        container_definitions   = jsonencode(
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

                # Health Check
                healthCheck : {
                    command  : ["CMD", "/app", "--healthcheck"],
                    interval : 30,
                    timeout  : 5,
                    retries  : 3,
                    startPeriod : 0
                },
            }
          ]
        )
      }
    }
  }

  depends_on = [
    aws_db_instance.database, # Database should exist before ECS task
  ]
}

#Networking & Security
# TODO: Refactor to ingress / egress rules
resource "aws_security_group" "ecs" {
  name = "${var.project}-${local.environment}-ecs-sg"
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

# CloudWatch Logs
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project}-${local.environment}-logs"
  retention_in_days = 7
}