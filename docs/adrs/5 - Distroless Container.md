## Status
Accepted

## Context
The container needs a base image for production-grade operations.

## Decision
Given the small size and complexity of the application, and that Go can build static binaries, a distroless static image is a good choice for the base image.

Taking into consideration that the base image for the build is `golang:1.21.11-bookworm`, the image chosen was `gcr.io/distroless/static-debian12:nonroot`, choosing the non-root variant for added security.

## Consequences
1. Lighter image size.
2. Faster cold start times.
3. Reduced attack surface.
4. Since since the distroless image doesn't have a shell or package manager, a `--healthcheck` option needed to be implemented as part of the program binary for the ECS Task level health check to work.