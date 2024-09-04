variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-2"

}

variable "app_name" {
  description = "The name of the application"
  type        = string
}

# ECS
variable "image" {
  description = "The Docker image to use for the ECS task"
  type        = string
}

variable "container_port" {
  description = "The port the container listens on"
  type        = number
  default     = 80
}