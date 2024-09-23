

resource "aws_iam_user_policy_attachment" "this" {
  for_each = var.policy_users
  
  user       = each.value
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_group_policy_attachment" "this" {
  for_each = var.policy_groups
  
  group      = each.value
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = var.policy_roles
  
  role       = each.value
  policy_arn = aws_iam_policy.this.arn
}
