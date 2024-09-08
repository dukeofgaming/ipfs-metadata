# The pipeline AWS account that is created in the environment module
data "aws_iam_user" "this" {
  user_name = var.aws_iam_user.name
}

# Create an access key for the user which will be stored 
# in Github Actions Environment Secrets
resource "aws_iam_access_key" "this" {
  user = data.aws_iam_user.this.user_name
}

data "github_repository" "this" {
  full_name = var.github_repository
}