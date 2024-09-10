resource "aws_iam_user" "environment_accounts" {
  for_each = var.accounts

  name = "${var.project_name}-${var.environment_name}-${each.key}"
  # path = "/${var.project_name}/${var.environment_name}/"

  tags = var.tags
}