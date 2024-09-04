module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.4.0"

  load_balancer_type = "application"
  security_groups = [
    module.vpc.default_security_group_id
  ]

  subnets = module.vpc.public_subnets
  vpc_id  = module.vpc.vpc_id

  security_group_rules = {

    ingress_all_http = {
      type = "ingress"

      protocol  = "TCP"
      from_port = var.container_port
      to_port   = var.container_port

      description = "Permit incoming HTTP requests from the internet"

      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }

    egress_all = {
      type = "egress"

      protocol  = "-1"
      from_port = 0
      to_port   = 0

      description = "Permit all outgoing requests to the internet"

      cidr_blocks = [
        "0.0.0.0/0"
      ]
    }

  }

  http_tcp_listeners = [
    {
      # Setup a listener on port 80 and forward all HTTP
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
}