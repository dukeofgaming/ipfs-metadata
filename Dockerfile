ARG GO_VERSION=1.21.11

# Build stage: Base image based on debian12
FROM golang:${GO_VERSION}-bookworm AS build

WORKDIR /app

# Copy go mod and sum files first to download dependencies and cache them in it's own layer
COPY \
    ./go.mod \
    ./go.sum \
    ./

RUN go mod download

# Copy the rest of the source code
COPY ./ ./

RUN \
    CGO_ENABLED=0 \
    go build -o /go/bin/app

# Production image stage
FROM gcr.io/distroless/static-debian12:nonroot

COPY --from=build /go/bin/app /app
COPY ./data ./data
COPY ./.env .

EXPOSE 8080

# Non-shell non-overridable form
CMD ["/app"]