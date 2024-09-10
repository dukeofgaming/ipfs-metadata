module "s3_backend" {
  source = "../aws-s3-backend"
  name   = "${var.project_name}-${var.environment_name}-tf-state"
}