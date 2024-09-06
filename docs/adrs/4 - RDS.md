## Status
In Progress

## Context
The project requires a Postgres database for the container. The options are RDS or a Postgres container.

## Decision
Use AWS RDS for the Postgres database instead of an additional task or sidecar Postgres container.

## Consequences

1. The database is managed by AWS, reducing the overhead of managing database operations.
2. Simpler to manage backups and disaster recovery.
3. The database is setup along with the rest of the app infrastructure making it possible to have a running system with minimal setup.



