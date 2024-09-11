## Status
Accepted

## Context
The project's requirements include best practices for infrastructure, Terraform and AWS as well as optimized workflows. 

The assumptions are that:

- Deployments should be secure and easy to work with.
- All infrastructure deployments should be automated.
- The project should be able to scale with the infrastructure.
- The project should be able to scale with the team.
- The project should support multiple secure environments.
- The Terraform state backend should be secure and scalable.
- There should be a promotion process to avoid conflicts between environments.

## Decision

Adopt GitOps with GitHub for infrastructure environment management, deployments and promotion using a simple implementation that can scale with the project. 

GitOps essentially means that the infrastructure is managed through Git, and changes are made through pull requests. In this model, our branches represent environments, and the promotion process is a simple merge.

Furthermore, communication on deployments done through tags, which later in the future can be used for managing rollback strategies, for example, by using GitHub Actions.


```mermaid
graph 
    subgraph "Environments"
        


        subgraph Core
            CoreTerraformState[(tfstate)]
            Pipelines
        end

        subgraph App
        
            subgraph Dev
                DevTerraformState[(tfstate)] 
            end


            subgraph Prod
                ProdTerraformState[(tfstate)]
            end
        end

        
        CoreTerraformState --creates--> DevTerraformState
        CoreTerraformState --creates--> ProdTerraformState

        

    end

```

In order to maintain fully automated deployments, a `Core` infrastructure project/environment will provision:

- Environments (e.g. Dev, Prod)
- State Backends (i.e. tfstate)
- User and service IAM accounts (e.g. GitHub)
- Pipelines and their Container Registry (i.e. GitHub Environments, Secrets, Variables)


Meanwhile the `App` infrastructure project will provision and be under GitHub's deployment automation:

- Application
- Database 
- Networking
- IAM


```mermaid
graph 
    subgraph "Environments"

        subgraph Core

            CoreTerraformState[(tfstate)]
            
            subgraph Pipelines
                subgraph ProdPipeline
                    ProdCICD([Github Environment])
                    ProdECR[(ECR)]
                end
            end
        end

        subgraph App
           

            subgraph Prod
                ProdTerraformState[(tfstate)]
                
                ProdECS(ECS) <--read/write--> ProdRDS[(RDS)]
                
                
                ProdTerraformState --creates--> ProdECS
                ProdTerraformState --creates--> ProdRDS


                
            end
        
        end

        ProdCICD --pushes--> ProdECR
        ProdCICD --controls--> ProdTerraformState

        CoreTerraformState --creates--> ProdTerraformState
        ProdECS --pulls--> ProdECR

        CoreTerraformState --creates--> ProdPipeline

    end

```

Finally, with these concepts put together, we can see how the environments are managed and promoted:

```mermaid
graph RL
    subgraph "Environments"

        
        
        subgraph Core
            subgraph Pipelines
                ProdPipeline
                DevPipeline
                
                DevPipeline--PR promotes to -->ProdPipeline
            end
        end

        subgraph App
           

            Dev
            
            Prod
        
        end

        DevPipeline([Dev Github Environment])--deploys-->Dev
        ProdPipeline([Prod Github Environment])--deploys-->Prod

    end

```

The promoetion from `dev` to `prod` will be handled by a simple merge, where there is a branch for each environment:

```mermaid
gitGraph 

    commit
    commit
    commit

    branch dev
    checkout dev
    commit
    commit
    commit
    commit tag: "deploy/dev/current"

    checkout main

    merge dev tag: "deploy/staging/current"
    commit
    commit
    commit
    commit

    branch prod
    checkout prod
    commit tag: "deploy/prod/current"
```

## Consequences

1. The `core` state for `environments` and separate user/service accounts can be provisioned by the "environments" Terraform project. 

2. The app Terraform project can be used securely with isolated service accounts.

3. Only the "environment" Terraform project needs a root/privileged account.

4. No human intervention needed to supply AWS access keys.

5. Opens the possibility for branch-based deployments for the dev environment e.g. with Terraform Workspaces (should not be used for major environments like  staging or production).

5. Doing [least-privileged](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#grant-least-privilege) IAM roles for the pipelines and services is a simple workflow.

6. The promotion process is simple and can be automated with GitHub Actions.