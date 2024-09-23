resource "aws_iam_policy" "this" {
  name        = var.policy_name
  description = var.policy_description

  policy = data.aws_iam_policy_document.this.json
}