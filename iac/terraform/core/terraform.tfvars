project_name      = "nft-ipfs-metadata"
github_repository = "dukeofgaming/ipfs-metadata"

environments = [ 
  "dev",
  "staging",
  "production" 
]

encrypted_environment_backends = [ 
  "production" 
]

pipelines = {               # The list of pipelines to deploy
  "dev" = {                 # The name of the pipeline
    environment       : "dev"     # The environment to deploy to

    branch              : "dev"     # The branch to deploy
    branch_promoting_to : "main"

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
    environment       : "staging"

    branch              : "main"
    branch_promoting_to : "prod"

    branch_protections = {
      force_push          : false,
      require_pr          : true,
      enforce_on_admins   : false,
      required_approvals  : 0
    }
  },

  "prod" = {
    environment   : "production"
    
    branch        : "prod"

    branch_protections = {
      require_pr          : true,
      force_push          : false,
      enforce_on_admins   : true,
      required_approvals  : 1
    }
  }
}

