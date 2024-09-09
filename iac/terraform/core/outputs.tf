# Relevant information from environments to configure app Terraform project,
# Github pipeine, etc.

locals {
  environments = {
    for environment in module.environments :
    environment.name => {
      name : environment.name

      s3_backend : {
        bucket : environment.s3_backend.bucket.id
        lock_table : environment.s3_backend.lock_table.id
      }

      accounts : {
        for account_alias, account in environment.accounts :

        account_alias => {
          id : account.id
          unique_id : account.unique_id
          arn : account.arn
          name : account.name
          path : account.path
        }
      }
    }
  }
}
output "environments" {
  description = "The list of environments"
  value       = local.environments
}

# Managed pipeline configuration
output "pipelines" {
  description = "The list of pipeline accounts"
  value       = module.pipelines
  sensitive   = false
}