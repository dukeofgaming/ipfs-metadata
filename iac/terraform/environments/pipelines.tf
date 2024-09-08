module "pipelines" {
  for_each = var.pipelines

  source    = "../modules/pipeline"

  environment   = each.value.environment
  branch        = each.value.branch

  github_repository = var.github_repository     # Same repository for all pipelines

  aws_iam_user = local.create_pipeline_account[each.value.environment] == true ? {
    name : module.environments[each.value.environment].accounts["pipeline"].name
    path : module.environments[each.value.environment].accounts["pipeline"].path
  } : var.pipelines[each.value.environment].aws_iam_user

}