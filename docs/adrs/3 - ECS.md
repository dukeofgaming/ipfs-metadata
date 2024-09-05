## Status
Accepted

## Context
The project requires a container orchestrataion platform to run the application on

## Decision
Use AWS ECS (Elastic Container Service) to run the application.

EKS was considered as an option, however, Kubernetes would add operational complexity, additional complexity to the pipeline as it would be preferable to use Helm and the use of the Helm provider for Terraform is not a best practice (e.g. state drift between Terraform and Helm).

## Consequences

1. ECS is a managed service, so it will require less operational overhead.
2. ECS integrates easier to other AWS services than EKS (e.g. CloudWatch).
3. ECS introduces less networking layers than EKS.
4. CICD pipelines can be simpler with ECS, relying only on Terraform.