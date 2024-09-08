resource "aws_iam_policy" "pipeline_permissions" {
  name        = "PipelinePermissionsPolicy"
  description = "Policy to grant permissions for pipeline operations"

  policy = data.aws_iam_policy_document.pipeline_permissions.json
}

data "aws_iam_policy_document" "pipeline_permissions" {
  # IAM permissions
  statement {
    actions = [
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  # EC2 permissions
  statement {
    actions = [
      "ec2:DescribeImages",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeRouteTables",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroupRules",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeInstanceTypes", 
      "ec2:DescribeAddresses"      
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  # Elastic Load Balancing permissions
  statement {
    actions = [
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes" 
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  # ECS permissions
  statement {
    actions = [
      "ecs:DescribeClusters"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  # CloudWatch Logs permissions
  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:ListTagsForResource"
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  # RDS permissions
  statement {
    actions = [
      "rds:DescribeDBParameterGroups",
      "rds:DescribeDBParameters",
      "rds:ListTagsForResource",
      "rds:DescribeDBSubnetGroups",
      "rds:DescribeDBInstances" 
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

resource "aws_iam_user_policy_attachment" "pipeline_permissions" {
  user       = data.aws_iam_user.this.user_name
  policy_arn = aws_iam_policy.pipeline_permissions.arn
}