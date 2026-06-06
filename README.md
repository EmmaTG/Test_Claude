# backend

A small Go backend you can develop locally with Claude Code in the loop. One
`docker compose` command brings up the Go microservice, a Postgres database, and
(optionally) a containerized Claude Code CLI that shares the repository.

## Architecture

| Service       | What it is                                | Port  |
|---------------|-------------------------------------------|-------|
| `api`         | Go microservice (`backend/microservice`)  | 8080  |
| `postgres_db` | Postgres 16 (`mydb` / `myuser`)           | 5432  |
| `claude`      | Claude Code CLI container (dev assistance)| —     |

All three share a single Docker bridge network, so `api` reaches the database at
`postgres_db:5432`.

## Prerequisites

- Docker + Docker Compose
- `ANTHROPIC_API_KEY` in your environment (used by the `claude` service)

## Run

```bash
export ANTHROPIC_API_KEY=...        # required by the claude service
docker compose up --build           # start everything
# or just the API + its database:
docker compose up --build api
```

Then:

```bash
docker compose logs -f api          # follow the service logs
docker compose down                 # stop (add -v to also wipe the DB volume)
```

The database is exposed on `localhost:5432` for local tooling.

## Configuration

The `api` service is configured entirely through environment variables (set in
`docker-compose.yaml`):

| Variable                          | Purpose            |
|-----------------------------------|--------------------|
| `DB_HOST` / `DB_PORT`             | Database location  |
| `DB_USER` / `DB_PASSWORD`         | Database credentials |
| `DB_NAME`                         | Database name      |
| `APP_PORT`                        | Port the API listens on |

## Status

Early scaffolding. `api` currently connects to Postgres and verifies the
connection on startup; the HTTP server and database schema are the next steps.
See `CLAUDE.md` for development context.
