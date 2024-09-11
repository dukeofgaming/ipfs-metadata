# Base default configuration run for every environment
#
# If you want to override values for a given environment,
# modify the terraform-<environment>.tfvars.
#
# The pipeline will modify a terraform-<environment>.tfvars.json
# on each promotion after a succesful deployment.
#
# WARNING: these files should not be updated manually.
# 

project = "nft-ipfs-metadata"

database_name = "nftipfsmetadata"

container_port = 8080

#Turning off the circuit breaker for all environments
ecs_circuit_breaker = {
  enable : false
  rollback : false
}