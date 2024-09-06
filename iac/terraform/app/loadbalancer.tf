module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.4.0"

  # Load Balancing  
  load_balancer_type = "application"
  http_tcp_listeners = [
    {
      # Setup a listener on container port and forward all HTTP
      # traffic to target_groups[0] below which
      # will point to our app.
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      backend_port     = var.container_port
      backend_protocol = "HTTP"
      target_type      = "ip"
    }
  ]

  # Networking
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets


  # Security
  security_groups = [
    module.vpc.default_security_group_id
  ]

  security_group_rules = {
    ingress_all_http = {
      type = "ingress"
      description = "Permit incoming HTTP requests from the internet"

      protocol  = "TCP"
      from_port = 80
      to_port   = 80


      cidr_blocks = ["0.0.0.0/0"]
    }

    egress_all = {
      type = "egress"
      description = "Permit all outgoing requests to the internet"

      protocol  = "-1"
      from_port = 0
      to_port   = 0


      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}