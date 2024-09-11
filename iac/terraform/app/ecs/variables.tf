
variable "environment_variables" {
  description = "The environment variables for the pipelines"
  type        = map(object({
    name        = string
    value       = string
    is_secret   = optional(bool, false)
  }))

  
}