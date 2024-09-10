locals {
  create_pipeline_account = tomap({
    for pipeline in var.pipelines :
    pipeline.environment => pipeline.aws_iam_user.name == null ? true : false
  })

  branch_environment_map = {
    for pipeline in values(var.pipelines): 
      pipeline.branch => pipeline.environment
  }

  branch_promotion_map = {
    for pipeline in values(var.pipelines):
      pipeline.branch => pipeline.branch_promoting_to
  }
}

# Create branch-environment-map.json with branches/patterns as keys
# and environments as values

resource "null_resource" "branch_environment_map" {
  
  triggers = {
    branches_changed      = jsonencode(keys(local.branch_environment_map))
    environments_changed  = jsonencode(values(local.branch_environment_map))
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOF
      echo '${jsonencode(local.branch_environment_map)}' \
        > ${var.json_branch_environment_map_path}
    EOF
  }
}

resource "null_resource" "branch_promotion_map" {
  triggers = {
    branches_changed      = jsonencode(keys(local.branch_environment_map))
    environments_changed  = jsonencode(values(local.branch_environment_map))
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = <<-EOF
      echo '${jsonencode(local.branch_promotion_map)}' \
        > ${var.json_branch_promotion_map_path}
    EOF
  }
}