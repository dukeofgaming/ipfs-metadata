
output "github_repository" {
  description = "The GitHub repository for the pipelines"
  value       = data.github_repository.this.http_clone_url
}

output "pipeline_aws_iam_user" {
  description = "The AwS IAM user for the pipelines"
  value       = data.aws_iam_user.this
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}


output "pipeline_environment" {
  description = "The GitHub environment for the pipeline"
  value       = github_repository_environment.pipeline_environment
  sensitive   = true
}

output "pipeline_secrets" {
  description = "The GitHub secrets for the pipelines"
  value = { for secret_name, secret in github_actions_environment_secret.pipeline_secrets :
    secret_name => {
      id : secret.id
      name : secret.secret_name
      created_at : secret.created_at
      updated_at : secret.updated_at
    }
  }
}

output "pipeline_variables" {
  description = "The GitHub variables for the pipelines"
  value = { for variable_name, variable in github_actions_environment_variable.pipeline_variables :
    variable_name => {
      id : variable.id
      name : variable.variable_name
      value : variable.value
      created_at : variable.created_at
      updated_at : variable.updated_at
    }
  }
}