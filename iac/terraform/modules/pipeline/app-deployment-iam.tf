locals {
  yaml_policy_statements_path  = "${path.module}/policy_statements"
  
}

module "pipeline_user_policy" {
  source = "../aws-iam-policy"

  policy_name         = "PipelinePermissionsPolicy-${var.name}-${var.environment}"
  policy_description  = "Policy to grant permissions for pipeline operations"
  
  policy_document     = {
    version   = "2012-10-17"
    statements = {
      for file_name in fileset(local.yaml_policy_statements_path, "*.yml") : 
        split(".", file_name)[0] => yamldecode(
          file("${local.yaml_policy_statements_path}/${file_name}")
        )
    }
  }
  
  policy_users        = [data.aws_iam_user.this.user_name]
}