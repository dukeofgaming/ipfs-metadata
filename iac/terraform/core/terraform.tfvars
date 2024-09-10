project_name      = "nft-ipfs-metadata"
github_repository = "dukeofgaming/ipfs-metadata"

environments = [ 
  "dev",
  "staging",
  "production" 
]

pipelines = {               # The list of pipelines to deploy
  "dev" = {                 # The name of the pipeline
    branch      : "dev"     # The branch to deploy
    environment : "dev"     # The environment to deploy to

    branch_protections = {  
      force_push          : false,
      require_pr          : true,
      required_approvals  : 0
      enforce_on_admins   : false,
    }
  },

  # "branch-based-deployments"  = {               #TODO: Test this
  #   branch      : "*[0-9]-*"                    # Glob pattern for branches coming from GitHub Issues
  #   environment : "dev/{terraform.workspace}"   # The environment to deploy, setting the terraform workspace
  # }

  "staging" = {
    branch      : "main"
    environment : "staging"

    branch_protections = {
      force_push          : false,
      require_pr          : true,
      enforce_on_admins   : false,
      required_approvals  : 1
    }
  },

  "prod" = {
    environment   : "production"
    
    branch        : "prod"
    branch_protections = {
      force_push          : false,
      require_pr          : true,
      enforce_on_admins   : true,
      required_approvals  : 1
    }
  }
}

