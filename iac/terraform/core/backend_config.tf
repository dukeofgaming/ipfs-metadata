locals {
    backends = {
      for environment_name, environment in local.environments: 
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
resource "null_resource" "update_app_backend_hcl_each" {
  # Filter out 'core' from local.backends if var.setup_core_environment is true
  for_each = var.update_app_backend_hcl ? { 
    for environment_name, environment in local.backends : 
      environment_name => environment if !(var.setup_core_environment && environment_name == "core")
  } : {}

  triggers = {
    bucket            = "${each.value.bucket}"
    dynamodb_table    = "${each.value.dynamodb_table}"
    key               = "${each.value.key}"
    region            = "${var.region}"
    environment_name  = "${each.key}"
    #always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p ../app
      echo 'bucket          = "${each.value.bucket}"' > ../app/backend-${each.key}.hcl
      echo 'dynamodb_table  = "${each.value.dynamodb_table}"' >> ../app/backend-${each.key}.hcl
      echo 'key             = "${each.value.key}"' >> ../app/backend-${each.key}.hcl
      echo 'region          = "${var.region}"' >> ../app/backend-${each.key}.hcl
    EOT
  }
}

