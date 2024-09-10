
resource "aws_lb" "alb" {
  name               = var.project
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    "Service" = "ECS"
    "Name"    = "${var.project}-${local.environment}-alb"
  }
}

resource "aws_security_group" "alb_sg" {
  description = "Allow all traffic to ALB"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow all TCP traffic in through port 80 from the internet"

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
    "Service" = "ECS"
    "Name"    = "${var.project}-${local.environment}-alb-sg"
  }
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_lb_target_group" "app" {
  name = var.project

  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  protocol = "HTTP"
  port     = var.container_port

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-499" 
  }

  depends_on = [
    aws_lb.alb
  ]

  tags = {
    "Service" = "ECS"
    "Name"    = "${var.project}-${local.environment}-target-group"
  }
}
