# File generator for main configuration variable, github_repository
# which gets saved as terraform.tfvars.json
resource "local_file" "tfvars_json" {
  filename = "${path.module}/terraform.tfvars.json"
  content = jsonencode({
    github_repository = var.github_repository
  })
}