# CLAUDE.md

Project context for Claude Code. Keep this current — it's loaded every session.

## What this is

A small Go backend developed locally with Claude-in-the-loop. `docker compose`
brings up the Go microservice, a Postgres database, and a containerized Claude
Code CLI that shares the repo.

## Layout

```
.
├── docker-compose.yaml          # 3 services: claude, api, postgres_db
├── Dockerfile                   # the `claude` service (Node + claude-code CLI)
├── backend/microservice/        # the Go service (module: microservice-test)
│   ├── Dockerfile               # multi-stage build of the `api` service
│   ├── go.mod / go.sum          # Go 1.26, github.com/lib/pq
│   └── src/main.go              # entrypoint
└── frontend/                    # empty (not started)
```

## Services (docker-compose.yaml)

- **api** — Go service, port `8080`, reads `DB_*` and `APP_PORT` from env.
- **postgres_db** — Postgres 16, db `mydb` / user `myuser`, healthchecked on `pg_isready`.
- **claude** — Claude Code CLI container; mounts the repo, needs `ANTHROPIC_API_KEY`.

## Run it

```bash
# from repo root
export ANTHROPIC_API_KEY=...      # required by the claude service
docker compose up --build         # brings up api + postgres_db (+ claude)
docker compose up --build api     # just the Go service + its db dependency
docker compose logs -f api        # watch the service
docker compose down               # stop (add -v to wipe the pgdata volume)
```

The DB is reachable from the host on `localhost:5432` and from `api` at
`postgres_db:5432`.

## Current state

- `src/main.go` connects to Postgres and `Ping()`s it, then exits. There is
  **no HTTP server yet** (`// Start your HTTP server here...`) and **no schema /
  migrations**. Building these out is the active work.

## Conventions

- Config comes from environment variables (see compose), never hardcoded.
- Standard Go layout; keep new packages under `backend/microservice/src` or a
  sibling package within the module until structure demands otherwise.

## Workflow

- Claude proposes a plan before all changes and works on a branch.
- Claude and create commit, push on a feature branch and create a pull requests.
