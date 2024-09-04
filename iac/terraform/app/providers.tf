provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      "Terraform"   = "true"
      "Environment" = local.environment
      "Project"     = var.project
    }
  }
}