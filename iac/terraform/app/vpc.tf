
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets_ecs = [
    "10.0.1.0/24",
    "10.0.2.0/24",
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.13.0"

  cidr = "10.0.0.0/16"
  azs  = local.availability_zones

  create_igw         = true # Expose public subnetworks to the Internet
  enable_nat_gateway = true # Hide private subnetworks behind NAT Gateway
  single_nat_gateway = true

  private_subnets = local.private_subnets_ecs

  public_subnets = [
    "10.0.101.0/24",
    "10.0.102.0/24"
  ]
}

resource "aws_security_group_rule" "allow_outbound_https" {
  type = "egress"

  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "tcp"
  from_port   = 443
  to_port     = 443

  security_group_id = module.vpc.default_security_group_id
}

resource "aws_security_group_rule" "name" {
  type = "ingress"

  cidr_blocks = ["0.0.0.0/0"]
  protocol    = "tcp"
  from_port   = var.container_port
  to_port     = var.container_port

  security_group_id = module.vpc.default_security_group_id
}