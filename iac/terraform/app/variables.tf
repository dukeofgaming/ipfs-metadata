variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-2"
}

variable "project" {
  description = "The name of the application"
  type        = string
}

variable "app_version" {
  description = "The version of the application"
  type        = string
  default     = "TERRAFORM_INITIALIZED"
}

variable "environment" {
  description = "The environment to deploy the application"
  type        = string
  default     = "dev"
}

# ECS
variable "container_image" {
  description = "The Docker image to use for the ECS task"
  type        = string
}

variable "container_port" {
  description = "The port the container listens on"
  type        = number
}

variable "container_environment" {
  description = "The environment variables to pass to the container"
  type        = map(any)
  default     = null
}

variable "ecs_circuit_breaker" {
  description = "Enable circuit breaker for ECS service"
  type = object({
    enable : optional(bool, true)
    rollback : optional(bool, true)
  })
  default = {}
}

variable "healthcheck_endpoint" {
  description = "The endpoint to use for the healthcheck"
  type        = string
  default     = "/healthcheck"
}

variable "healtcheck_matcher" {
  description = "The matcher to use for the healthcheck"
  type        = string
  default     = "200"
}

# RDS
variable "database_name" {
  description = "The name of the database"
  type        = string
  default     = null
}

variable "database_username" {
  description = "The username for the database"
  type        = string
  default     = null
}

variable "database_password" {
  description = "The master password for the database"
  type        = string
  sensitive   = true        
  default     = "INITIALIZED_BY_TERRAFORM"
}

variable "database_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
  default     = "db.t3.micro"
}

variable "database_port" {
  description = "The port the database listens on"
  type        = number
  default     = 5432
}

variable "rds_master_password_secret_recovery_window_in_days" {
  description = "The number of days to retain the secret"
  type        = number
  default     = 0

}