terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.65.0"
    }
    
    github = {
      source  = "integrations/github"
      version = "~> 6.2.3"
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

locals {
  create_pipeline_account = tomap({
    for pipeline in var.pipelines: 
      pipeline.environment => pipeline.aws_iam_user.name == null ? true : false
  })
}

module "environments" {
  for_each = setunion(
    var.environments,
    var.setup_core_environment ? ["core"] : []
  )

  source = "../modules/environment"

  project_name     = var.project_name
  environment_name = each.value
  
  accounts = setunion(
    lookup(var.environment_accounts, each.value, []), 
    lookup(
      local.create_pipeline_account, 
      each.value, 
      false       # Only not found if there is a core environment, no pipeline is created for this
    ) ? ["pipeline"] : []
  )

  tags = merge(
    var.tags,
    {
      "environment" = each.value
    }
  )
}