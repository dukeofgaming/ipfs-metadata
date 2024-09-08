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


# AWS
variable "aws_iam_user" {
    description = "The AWS account ID for the pipeline to deploy resources"
    type        = object({
      name : string
      path : string
    })
}

# GitHub
variable "github_repository" {
    description = "The GitHub repository for the pipeline in a <owner>/<repo> format"
    type        = string
}