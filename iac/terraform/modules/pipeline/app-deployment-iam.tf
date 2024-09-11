resource "aws_iam_policy" "pipeline_permissions" {
  name        = "PipelinePermissionsPolicy-${var.name}-${var.environment}"
  description = "Policy to grant permissions for pipeline operations"

  policy = data.aws_iam_policy_document.pipeline_permissions.json
}


data "aws_iam_policy_document" "pipeline_permissions" {
  version = "2012-10-17"

  statement {
    actions = [
      "iam:GetRole",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
      "iam:PassRole",
      "iam:DetachRolePolicy",
      "iam:ListInstanceProfilesForRole",
      "iam:DeleteRole",
      "iam:CreateRole",
      "iam:TagRole",
      "iam:AttachRolePolicy",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:ListPolicyVersions",
      "iam:DeletePolicy",
      "iam:CreatePolicy",
      "iam:TagPolicy"
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
      "ec2:DescribeAddresses",
      "ec2:DescribeTags",
      "ec2:DescribeAddressesAttribute",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeNatGateways",
      "ec2:DescribeVolumes",
      "ec2:DescribeInstanceCreditSpecifications",
      "ec2:DescribeNetworkInsightsPaths",
      "ec2:DescribeNetworkInsightsAnalyses",
      "ec2:DisassociateRouteTable",
      "ec2:DeleteRoute",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:DeleteNetworkInsightsAnalysis",
      "ec2:DeleteNatGateway",
      "ec2:DeleteNetworkInsightsPath",
      "ec2:DeleteRouteTable",
      "ec2:DisassociateAddress",
      "ec2:TerminateInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteSubnet",
      "ec2:ReleaseAddress",
      "ec2:DeleteSecurityGroup",
      "ec2:DetachInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteVpc",
      "ec2:CreateVpc",
      "ec2:CreateTags",
      "ec2:ModifyVpcAttribute",
      "ec2:CreateSecurityGroup",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:CreateSubnet",
      "ec2:CreateRouteTable",
      "ec2:CreateInternetGateway",
      "ec2:DeleteNetworkAclEntry",
      "ec2:RunInstances",
      "ec2:AttachInternetGateway",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateNetworkAclEntry",
      "ec2:AllocateAddress",
      "ec2:CreateRoute",
      "ec2:CreateNetworkInsightsPath",
      "ec2:CreateNatGateway",
      "ec2:StartNetworkInsightsAnalysis",
      "ec2:AssociateRouteTable",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  # Updated Tiros permissions for Network Insights
  # Tiros permissions for Network Insights
  # statement {
  #   actions = [
  #     "tiros:CreateQuery",                  # Create a new query for insights
  #     "tiros:StartQuery",                   # Start a query to gather insights
  #     "tiros:CreateRoute",                  # Create routes for network traffic insights
  #     "tiros:ListPaths",                    # List available network paths
  #     "tiros:ReadPermissions",              # Read the permissions set for Tiros
  #     "tiros:ModifyPermissions",            # Modify permissions for Tiros operations
  #     "tiros:StartAnalysis",                # Start network insights analysis
  #     "tiros:StartExecution",               # Execute the insights analysis process
  #     "tiros:ExecuteAnalysis",              # Actually run the analysis operation
  #     "tiros:ViewResults",                  # View the results of the analysis
  #     "tiros:ListExecutions",               # List the executed analysis jobs
  #     "tiros:ViewNetworkInsightsResults",   # View network insight analysis results
  #     "tiros:DeleteNetworkInsightsAnalysis",# Delete completed or failed analyses
  #     "tiros:StartNetworkInsightsAnalysis", # Start the process for insights analysis
  #     "tiros:StopExecution",                # Stop an in-progress analysis
  #     "tiros:ViewNetworkInsightsPaths",     # View the network paths set for analysis
  #     "tiros:DescribeNetworkInsightsResults", # Describe the details of the insights results
  #     "tiros:DescribePermissionsBoundary",  # Describe the permissions boundary for Tiros
  #     "tiros:CreatePermissionsBoundary",    # Create a permissions boundary for Tiros
  #     "tiros:ListPermissions",              # List the permissions available for Tiros
  #     "tiros:CreateNetworkInsightsPath",    # Create a network insights path
  #     "tiros:CreateRoute",                  # Create a route for traffic insights
  #     "tiros:DeleteNetworkInsightsPath",    # Delete an existing network insights path
  #     "tiros:CreateNetworkInsightsAnalysis",# Start the network insights analysis process
  #     "tiros:DeleteAnalysis",               # Delete an existing analysis job
  #     "tiros:StopAnalysis"                  # Stop an in-progress network insights analysis
  #   ]
  #   resources = ["*"]
  #   effect    = "Allow"
  # }



  # Elastic Load Balancing permissions
  statement {
    actions = [
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:CreateListener",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  # ECS permissions
  statement {
    actions = [
      "ecs:DescribeClusters",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeServices",
      "ecs:DeregisterTaskDefinition",
      "ecs:RegisterTaskDefinition",
      "ecs:TagResource",
      "ecs:UpdateService",
      "ecs:DeleteService",
      "ecs:PutClusterCapacityProviders",
      "ecs:DeleteCluster",
      "ecs:CreateCluster",
      "ecs:CreateService",
    ]
    resources = ["*"]
    effect    = "Allow"
  }

  # CloudWatch Logs permissions
  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:ListTagsForResource",
      "logs:DeleteLogGroup",
      "logs:CreateLogGroup",
      "logs:TagResource",
      "logs:PutRetentionPolicy",
    ]
    resources = ["*"]
    effect    = "Allow"
  }
  # Adjusted Secrets Manager permissions to include GetResourcePolicy
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:DescribeSecret",
      "secretsmanager:CreateSecret",
      "secretsmanager:PutSecretValue",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DeleteSecret",
      "secretsmanager:UpdateSecret",
      "secretsmanager:ListSecretVersionIds",
      "secretsmanager:RestoreSecret",
      "secretsmanager:TagResource"
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
      "rds:DescribeDBInstances",
      "rds:DeleteDBInstance",
      "rds:DeleteDBParameterGroup",
      "rds:DeleteDBSubnetGroup",
      "rds:CreateDBParameterGroup",
      "rds:AddTagsToResource",
      "rds:ModifyDBParameterGroup",
      "rds:CreateDBInstance",
      "rds:CreateDBSubnetGroup",
      "rds:ModifyDBInstance" 
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}



resource "aws_iam_user_policy_attachment" "pipeline_permissions" {
  user       = data.aws_iam_user.this.user_name
  policy_arn = aws_iam_policy.pipeline_permissions.arn
}