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

  generated_hcl_file_path = each.value == "core" ? (
    "${path.module}/backend.hcl"
  ) : "${path.module}/../app/backend-${each.key}.hcl"

  tags = merge(
    var.tags,
    {
      "environment" = each.value
    }
  )
}