## Status
In Progress

## Context
The project requires a Postgres database for the container. The options are RDS or a Postgres container.

## Decision
Use AWS RDS for the Postgres database instead of an additional task or sidecar Postgres container.

The main rationale is reducing the overhead of managing database operations, including backups and disaster recovery.

## Consequences

1. ...


