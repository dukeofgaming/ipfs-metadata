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

resource "local_file" "branch_environment_map" {
  filename = "${var.json_branch_environment_map_path}"
  content  = jsonencode(local.branch_environment_map)
}

resource "local_file" "branch_promotion_map" {
  filename = "${var.json_branch_promotion_map_path}"
  content  = jsonencode(local.branch_promotion_map)
}