module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.2.1"

  repository_force_delete = true
  repository_name         = var.project
  repository_lifecycle_policy = jsonencode({
    rules = [{
      action = {
        type = "expire"
      }
      description  = "Delete all images except a handful of the newest images"
      rulePriority = 1
      selection = {
        countNumber = 3
        countType   = "imageCountMoreThan"
        tagStatus   = "any"
      }
    }]
  })

}