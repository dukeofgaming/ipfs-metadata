variable "aws_region" {
  description   = "The AWS region to deploy the resources"
  type          = string
  default       = "us-east-2"
  
}

variable "image" {
  description = "The Docker image to use for the ECS task"
  type        = string
}