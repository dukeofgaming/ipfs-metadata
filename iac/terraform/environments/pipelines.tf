module "pipelines" {
  for_each = var.pipelines

  source = "../modules/pipeline"

  ecr_repository_name = "${var.project_name}-${each.value.environment}"

  environment = each.value.environment
  branch      = each.value.branch

  backend = {
    dynamodb_table_arn = module.environments[each.value.environment].s3_backend.lock_table.arn
    s3_bucket_arn      = module.environments[each.value.environment].s3_backend.bucket.arn
  }

  github_repository = var.github_repository # Same repository for all pipelines

  aws_iam_user = local.create_pipeline_account[each.value.environment] == true ? {
    name : module.environments[each.value.environment].accounts["pipeline"].name
    path : module.environments[each.value.environment].accounts["pipeline"].path
  } : var.pipelines[each.value.environment].aws_iam_user

}