locals {
    backends = {for environment_name, environment in local.environments: 
        environment.name => {
            bucket          = environment.s3_backend.bucket
            dynamodb_table  = environment.s3_backend.lock_table
            key             = "terraform.tfstate"
            region          = var.region
        }
    }

    core_backend = var.setup_core_environment ? {
        bucket          = local.backends["core"].bucket
        dynamodb_table  = local.backends["core"].dynamodb_table
        key             = "terraform.tfstate"
        region          = var.region
    } : {
        bucket          = ""
        dynamodb_table  = ""
        key             = ""
        region          = ""
    }
}

resource "null_resource" "update_backend_hcl" {
  count = var.setup_core_environment && var.update_backend_hcl ? 1 : 0

  triggers = {
    s3_bucket_update = local.core_backend.bucket
    s3_table_update  = local.core_backend.dynamodb_table
    #always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo 'bucket          = "${local.core_backend.bucket}"' > backend.hcl
      echo 'dynamodb_table  = "${local.core_backend.dynamodb_table}"' >> backend.hcl
      echo 'key             = "${local.core_backend.key}"' >> backend.hcl
      echo 'region          = "${var.region}"' >> backend.hcl
    EOT
  }
}
