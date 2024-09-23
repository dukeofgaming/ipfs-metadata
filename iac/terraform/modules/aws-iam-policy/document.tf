

# locals {
#   yaml_policy_statements_path  = "${path.module}/policies"
#   yaml_fileset        = fileset(local.yaml_policy_statements_path, "*.yml")
#   policy_yaml_files   = { 
#     for file_name in local.yaml_fileset : 
#       split(
#         ".",
#         file_name
#       )[0] => yamldecode(
#         file("${local.yaml_policy_statements_path}/${file_name}")
#       ) 
#   }
# }


data "aws_iam_policy_document" "this" {
  version = var.policy_document.version

  dynamic statement {
    for_each = var.policy_document.statements
    content{
      sid       = statement.value.use_key_as_sid ? statement.key : statement.value.sid

      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = statement.value.principals
        content{
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

    }
  }
}
