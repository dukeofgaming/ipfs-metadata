variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-2"

}

variable "project" {
  description = "The name of the application"
  type        = string
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
  default     = 80
}

#TODO: Implement "valueFrom" for AWS Secrets Manager
variable "container_environment" {
  description = "The environment variables to pass to the container"
  type        = map(any)
  default     = null
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
  description = "The password for the database"
  type        = string
  # sensitive   = true
  default = "password" #TODO: REMOVE THIS LINE
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