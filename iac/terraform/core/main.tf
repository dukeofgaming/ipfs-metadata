locals {
  create_pipeline_account = tomap({
    for pipeline in var.pipelines :
    pipeline.environment => pipeline.aws_iam_user.name == null ? true : false
  })
}
