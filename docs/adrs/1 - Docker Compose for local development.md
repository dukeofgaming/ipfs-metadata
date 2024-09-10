## Status
Proposed

## Context
Local development should be fast and cheap to execute while allowing to test the complete system.

## Decision
Use Docker Compose for simplicity to start and setup local development for the complete system.

## Consequences

1. Single command startup and shutdown of the complete system.
2. `.env` file is reusable between golang app and docker-compose.
3. Simple startup with `docker-compose up --build`
4. Clean shutdown with `docker-compose down --volumes`


