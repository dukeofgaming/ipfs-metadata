variable "cluster_name" {
  description = "The name of the ECS cluster to create"
  type        = string
}

variable "services" {
  description = "The services to create in the ECS cluster"
  type        = map(object({ //Key is the service name
    desired_count = number
    launch_type = optional(string, "FARGATE")

    deployment_controller       = optional(string, "ECS")
    deployment_circuit_breaker  = optional(object({
      enable   = optional(bool, true)
      rollback = optional(bool, true)
    }))

    load_balancer = optional(object({
      container_name   = string
      container_port   = number
      target_group_arn = string
    }))

    network_configuration = optional(object({
      subnets = list(string)
      security_groups = list(string)
    }))

    task_definition = object({
      cpu     = optional(number, 256)
      memory  = optional(number, 512)

      requires_compatibilities = optional(list(string), ["FARGATE"])

      execution_role_arn  = optional(string)
      task_role_arn       = optional(string)

      network_mode        = optional(string, "awsvpc")

      container_definitions = string
    })
  }))
}

# variable "tasks" {
#   description = "The tasks to create in the ECS cluster"
#   type        = map(object({ //Key is the task name
    
#   }))
  
# }

# variable "container_definitions" {
#   description = "The container definitions for ECS"
#   type        = list(object({
#     name            = string
#     image           = string
#     cpu             = optional(number, 256)
#     memory          = optional(number, 512)
#     environment     = optional(map(string))
#     secrets         = optional(map(string))
#     port_mappings   = optional(list(object({
#       container_port = number
#       host_port      = number
#     })))
#   }))
  
# }

# variable "services" {
#   description = "The services to create in the ECS cluster"
#   type        = map(object({
    
#   }))
  
# }

# variable "alb_security_group_id" {
#   description = "The security group ID of the ALB"
#   type        = string
# }