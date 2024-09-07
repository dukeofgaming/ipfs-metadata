terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
  }


  #   Uncomment this after the first apply to use an S3 backend.
  #   If setup_core_environment is true, you will get a 
  #   bucket and dynamodb table for the core environment.
  #
  #   See README.md for more information.
  #
  backend "s3" {}
}



module "environments" {
  for_each = setunion(
    var.environments,
    var.setup_core_environment ? ["core"] : []
  )

  source = "../modules/environment"

  project_name     = var.project_name
  environment_name = each.value
  accounts = lookup(
    var.environment_accounts,
    each.value,
    []
  )

  tags = merge(
    var.tags,
    {
      "environment" = each.value
    }
  )
}