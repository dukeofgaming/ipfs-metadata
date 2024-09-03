output "core_state" {
    description = "The state file for the core environment"
    value       = var.setup_core_environment ? {
        bucket          = module.environments["core"].s3_backend.bucket.id
        dynamodb_table  = module.environments["core"].s3_backend.lock_table.id
    }: null
}

output "environment_states" {
    description = "The state files for the other environments"
    value       = {
        for env in var.environments: env => {
            bucket          = module.environments[env].s3_backend.bucket.id
            dynamodb_table  = module.environments[env].s3_backend.lock_table.id
        }
    }
}