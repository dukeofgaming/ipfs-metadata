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
      false # Only not found if there is a core environment, no pipeline is created for this
    ) ? ["pipeline"] : []
  )

  encrypt_backend = contains(
    var.encrypted_environment_backends, 
    each.value
  )

  generated_hcl_file_path = (each.value == "core") ? (
    var.update_core_backend_hcl?("${path.module}/backend.hcl"):false
  ) : (
    var.update_app_backend_hcl?("${path.module}/../app/backend-${each.key}.hcl"):false
  )

  tags = merge(
    var.tags,
    {
      "environment" = each.value
    }
  )
}