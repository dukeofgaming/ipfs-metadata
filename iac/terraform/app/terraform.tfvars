project = "nft-ipfs-metadata"

## Images to test HTTP connectivity, default port is 80
# container_image = "nginx:latest"
# container_image = "nginx:1.27-alpine"

## Images to test Postgres connectivity
# container_image                 = "dpage/pgadmin4:8.10"
# container_image                 = "dpage/pgadmin4:8.11.0"
# # container_port = 80
# container_environment     = {
#     "PGADMIN_DEFAULT_EMAIL"     = "theadmin@noreply.com",
#     "PGADMIN_DEFAULT_PASSWORD"  = "password",
#     "PGADMIN_LISTEN_PORT"       = 80,
# }

# container_image = "371941937463.dkr.ecr.us-east-2.amazonaws.com/nft-ipfs-metadata-dev:latest"
container_image = "371941937463.dkr.ecr.us-east-2.amazonaws.com/nft-ipfs-metadata-dev:c20391b"
container_port  = 8080

database_name = "nftipfsmetadata"

ecs_circuit_breaker = {
  enable : false
  rollback : false
}