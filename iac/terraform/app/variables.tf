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