#!/usr/bin/env bash
# Wires up git + GitHub auth before launching Claude Code, so the container
# can push branches and create/review pull requests.
set -e

# The repo is bind-mounted and owned by a different uid on the host; without
# this, git refuses to operate ("detected dubious ownership").
git config --global --add safe.directory /app

# Commit identity (override via env in docker-compose / .env).
git config --global user.name  "${claude-bot}"
git config --global user.email "${claude-bot@users.noreply.github.com}"

# If a GitHub token is provided, make `git push` over HTTPS use it.
# gh reads GH_TOKEN from the environment automatically for its own API calls.
if [ -n "${GH_TOKEN:-}" ]; then
  gh auth setup-git
else
  echo "warning: GH_TOKEN not set — push and PR creation will not be authenticated." >&2
fi

git remote set-url origin https://${GH_TOKEN}@github.com/EmmaTG/Test_Claude.git

exec claude "$@"
