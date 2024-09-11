#Get current AWS retion
data "aws_region" "current" {}

locals {
    backend_bucket_id       = module.s3_backend.bucket.id
    backend_lock_table_id   = module.s3_backend.lock_table.id
}

resource "null_resource" "update_backend_hcl" {
  count = var.generated_hcl_file_path != null ? 1 : 0

  triggers = {
    s3_bucket_update = local.backend_bucket_id
    s3_table_update  = local.backend_lock_table_id
    always_run = "${timestamp()}"
  }

  provisioner "local-exec" {
    command = <<EOT
      echo 'bucket          = "${local.backend_bucket_id}"' > ${var.generated_hcl_file_path}
      echo 'dynamodb_table  = "${local.backend_lock_table_id}"' >> ${var.generated_hcl_file_path}
      echo 'key             = "${var.key}"' >> ${var.generated_hcl_file_path}
      echo 'region          = "${data.aws_region.current.name}"' >> ${var.generated_hcl_file_path}
    EOT
  }
}