data "github_branch" "this" {
  repository = data.github_repository.this.id
  branch     = var.branch
}

resource "github_branch_protection" "this" {
  repository_id = data.github_repository.this.id
  pattern     = var.branch

  enforce_admins        = var.branch_protections.enforce_on_admins  # Optional: Also enforce protection for repository admins

  allows_force_pushes   = var.branch_protections.force_push
  dynamic required_pull_request_reviews {
    for_each = var.branch_protections.require_pr ? [1] : []

    content {
      required_approving_review_count = var.branch_protections.required_approvals
      
    }
  }

  #TODO: Look into required_status_checks contexts: contexts = ["ci/build", "ci/deploy"] 
}