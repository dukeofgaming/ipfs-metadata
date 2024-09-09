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
    environment : "dev"     # The environment to deploy
  },


  # "branch-based-deployments"  = {               #TODO: Test this
  #   branch      : "*[0-9]-*"                    # Glob pattern for branches coming from GitHub Issues
  #   environment : "dev/{terraform.workspace}"   # The environment to deploy, setting the terraform workspace
  # }

  "staging" = {
    branch      : "main"
    environment : "staging"
  },

  "prod" = {
    branch        : "prod"
    environment   : "production"
  }
}

