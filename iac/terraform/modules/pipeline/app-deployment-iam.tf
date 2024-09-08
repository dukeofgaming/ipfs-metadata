resource "aws_iam_policy" "pipeline_permissions" {
  name        = "PipelinePermissionsPolicy"
  description = "Policy to grant permissions for pipeline operations"

  policy = data.aws_iam_policy_document.pipeline_permissions.json
}

data "aws_iam_policy_document" "pipeline_permissions" {
  statement {
    actions = [
        # IAM
        "iam:GetRole",

        # ECS
        "ecs:DescribeClusters",
        "ec2:DescribeImages",
        "logs:DescribeLogGroups",
        
        # RDS
        "rds:DescribeDBParameterGroups",

        # Networking
        "ec2:DescribeAvailabilityZones",
        "ec2:DescribeVpcs"
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_user_policy_attachment" "pipeline_permissions" {
  user       = data.aws_iam_user.this.user_name
  policy_arn = aws_iam_policy.pipeline_permissions.arn
}