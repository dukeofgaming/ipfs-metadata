resource "aws_iam_policy" "pipeline_permissions" {
  name        = "PipelinePermissionsPolicy-${var.name}-${var.environment}"
  description = "Policy to grant permissions for pipeline operations"

  policy = data.aws_iam_policy_document.pipeline_permissions.json
}

locals {
  # pipeline_iam_policy = yamldecode(file("${path.module}/policies/iam.yml"))

  yaml_policies_path = "${path.module}/policies"
  yaml_fileset      = fileset(local.yaml_policies_path, "*.yml")
  policy_yaml_files = { 
    for file_name in local.yaml_fileset : 
      split(
        ".",
        file_name
      )[0] => yamldecode(
        file("${local.yaml_policies_path}/${file_name}")
      ) 
  }
}


data "aws_iam_policy_document" "pipeline_permissions" {
  version = "2012-10-17"

  dynamic statement {
    for_each = local.policy_yaml_files
    content{
      effect    = local.policy_yaml_files[statement.key].policy.statements[0].effect
      actions   = local.policy_yaml_files[statement.key].policy.statements[0].actions
      resources = local.policy_yaml_files[statement.key].policy.statements[0].resources
    }
  }
}



resource "aws_iam_user_policy_attachment" "pipeline_permissions" {
  user       = data.aws_iam_user.this.user_name
  policy_arn = aws_iam_policy.pipeline_permissions.arn
}

