variable "setup_core_environment" {
    description = "The flag to setup the core environment"
    type        = bool
    default     = true
}

variable "project_name" {
    description = "The name of the project"
    type        = string
}

variable "environments" {
    description = "The list of environments to deploy the resources"
    type        = set(string)
    default     = ["dev"]
}

variable "environment_accounts" {
    description = "The map of environment to AWS account ID"
    type        = map(
        set(string)
    )

    default = {
        "dev"   = ["user", "pipeline"]
    }
  
}

variable "state_backend_name" {
    description = "The name of the S3 bucket to store the Terraform state file"
    type        = string
    default     = "terraform-state-backend"
}

variable "tags" {
    description = "The tags to apply to the resources"
    type        = map(string)
    default     = {}
}

variable "region" {
    description = "The AWS region to deploy the resources"
    type        = string
    default     = "us-east-2"
}