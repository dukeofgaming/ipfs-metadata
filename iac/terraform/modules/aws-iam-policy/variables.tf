variable "policy_name" {
  description = "The name of the IAM policy"
  type        = string
}

variable "policy_description" {
  description = "The description of the IAM policy"
  type        = string
}

variable "policy_documents" {
    description = "The policy document to attach to the IAM policy"
    type        = object({

        version   : optional(string)
        statement : map(
            object({                        # Key is statement id
                use_key_as_sid : optional(bool, false)

                sid       : optional(string)
                effect    : string
                actions   : set(string)
                resources : set(string)

                principals : optional(
                    set(
                        object({
                            type        : string
                            identifiers : set(string)
                        })
                    ), 
                    []
                )
            })
        )
    })
}

variable "policy_users" {
  description   = "The users to attach the IAM policy"
  type          = set(string)
  default       = []
}

variable "policy_groups" {
  description   = "The groups to attach the IAM policy"
  type          = set(string)
  default       = []
}

variable "policy_roles" {
  description   = "The roles to attach the IAM policy"
  type          = set(string)
  default       = []
}

