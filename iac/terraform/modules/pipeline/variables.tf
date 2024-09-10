variable "ecr_repository_name" {
  description = "The project name for the pipeline"
  type        = string
}

variable "environment" {
  description = "The environment to deploy the pipeline"
  type        = string
}

variable "branch" {
  description = "The branch to deploy the pipeline"
  type        = string
}

variable "branch_promoting_to" {
  description = "The branch to promote to the environment"
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the pipeline"
  type        = string
}

# AWS
#TODO: Convert to collection
variable "aws_iam_user" {
  description = "The AWS account ID for the pipeline to deploy resources"
  type = object({
    name : string
    path : string
  })
}

variable "backend" {
  description = "The backend configuration for the pipeline"
  type = object({
    s3_bucket_arn : string
    dynamodb_table_arn : string
  })
}

# GitHub
variable "github_repository" {
  description = "The GitHub repository for the pipeline in a <owner>/<repo> format"
  type        = string
}

variable "branch_protections" {
  description = "The branch protections for the pipeline"
  type        = object({
    require_pr          : optional(bool, false)
    force_push          : optional(bool, false)
    enforce_on_admins   : optional(bool, false)
    required_approvals  : optional(number, 0)
  })
}