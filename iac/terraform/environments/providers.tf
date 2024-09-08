locals {
  tags = merge(
    var.tags,
    {
      "project" = var.project_name
    }
  )
}

provider "aws" {
  region = var.region
  default_tags {
    tags = local.tags
  }
}

provider "github" {}