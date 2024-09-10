terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }

  backend "s3" {}
}

locals {
  environment    = "${var.environment}-${terraform.workspace}"
  container_name = var.project
}