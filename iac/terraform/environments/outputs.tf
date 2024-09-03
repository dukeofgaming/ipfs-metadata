output "core_state" {
    description = "The state file for the core environment"
    value       = var.setup_core_environment ? {
        bucket          = module.environments["core"].s3_backend.bucket.id
        dynamodb_table  = module.environments["core"].s3_backend.lock_table.id
    }: null
}