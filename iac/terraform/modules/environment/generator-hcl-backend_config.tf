#Get current AWS retion
data "aws_region" "current" {}

locals {
    backend_bucket_id       = module.s3_backend.bucket.id
    backend_lock_table_id   = module.s3_backend.lock_table.id
}

resource "local_file" "backend_hcl" {
  count = var.generated_hcl_file_path != null ? 1 : 0

  filename = "${var.generated_hcl_file_path}"
  content = <<-EOF
    bucket          = "${local.backend_bucket_id}"
    dynamodb_table  = "${local.backend_lock_table_id}"
    key             = "${var.key}"
    region          = "${data.aws_region.current.name}"
    encrypt         = ${var.encrypt_backend ? "true" : "false"}
  EOF
}