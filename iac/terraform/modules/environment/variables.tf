variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "environment_name" {
  description = "The name of the environment"
  type        = string
}

variable "accounts" {
  description = "The list of accounts to create the IAM users"
  type        = set(string)
}

variable "tags" {
  description = "The tags to apply to the resources"
  type        = map(string)
}