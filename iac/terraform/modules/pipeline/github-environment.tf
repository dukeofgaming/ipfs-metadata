resource "github_repository_environment" "pipeline_environment" {
    repository  = data.github_repository.this.id
    
    environment = var.environment
}


# Environment secrets
locals {
  environment_secrets   = {
    AWS_ACCESS_KEY_ID     = aws_iam_access_key.this.id
    AWS_SECRET_ACCESS_KEY = aws_iam_access_key.this.secret
  }
}
resource "github_actions_environment_secret" "pipeline_secrets" {
    for_each = local.environment_secrets

  repository        = data.github_repository.this.id
  environment       = github_repository_environment.pipeline_environment.environment
  
  secret_name       = each.key
  plaintext_value   = each.value
}

data "aws_region" "current" {}

# Environment variables
locals {
    environment_variables = {
        AWS_REGION     = data.aws_region.current.name
    }
}

resource "github_actions_environment_variable" "pipeline_variables" {
    for_each = local.environment_variables

    repository        = data.github_repository.this.id
    environment       = github_repository_environment.pipeline_environment.environment

    variable_name = each.key
    value         = each.value
}