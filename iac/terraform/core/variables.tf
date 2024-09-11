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

variable "update_core_backend_hcl" {
  description = "The flag to update the backend configuration"
  type        = bool
  default     = true
}

variable "update_app_backend_hcl" {
  description = "The flag to update the backend configuration"
  type        = bool
  default     = true
}

variable "environment_accounts" {
  description = "Map of environment names to sets of AWS accounts"

  type = map(
    set(string)
  )

  default = {
    "dev" = []
  }
}

variable "json_branch_environment_map_path" {
  description = "The path to the branch-environment-map.json file"
  type        = string
  default     = "../../../.github/branch-environment-map.json"
}

variable "json_branch_promotion_map_path" {
  description = "The path to the branch-promotion-map.json file"
  type        = string
  default     = "../../../.github/branch-promotion-map.json"
  
}

variable "encrypted_environment_backends" {
  description = "The flag to encrypt the environment states"
  type        = set(string)
  default     = []
}

#TODO: Convert to YAML path to avoid variable definition duplication
variable "pipelines" {
  description = "The list of pipelines to deploy"
  type = map(                             # The key is the name of the pipeline
    object({        
      environment : string                # The environment to deploy to

      # GItHub 
      # TODO: dukeofgaming/ipfs-metadata#1
      branch : string                               # The branch to deploy from
      branch_promoting_to : optional(string, null)  # The branch to promote to
      branch_protections : optional(map(string),{}) # Map string to allow different native types (0 doesn't cast to false)

      # Pipeline must have an account, if none is supplied, one will be created
      aws_iam_user : optional(object({
        name : optional(string)
        path : optional(string, "/")
      }), {})

    })
  )

  validation {
    # Validate that the environment attribute exists in var.environments
    error_message = <<-EOT
      The pipeline environment must be one of the environments:

      ${join(", ", var.environments)}

      You can have environments without pipelines, but you 
      cannot have pipelines without environments.

      Please define it in the var.environments in your terraform.tfvars file
    EOT
    
    condition = alltrue([
      for pipeline_name, pipeline_details in var.pipelines : 
        contains(
          var.environments, 
          pipeline_details.environment
        )
    ])

  }
}

variable "github_repository" {
  description = "The GitHub repository for the pipeline"
  type        = string
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