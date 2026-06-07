FROM node:20-slim

# System dependencies:
#   git  - version control for the mounted repo
#   gh   - GitHub CLI: authenticates push over HTTPS and creates/reviews PRs
# gh is not in Debian's default repos, so add GitHub's official apt source.
RUN apt-get update && apt-get install -y --no-install-recommends \
        git ca-certificates curl gnupg \
    && mkdir -p -m 755 /etc/apt/keyrings \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
         -o /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
         > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y --no-install-recommends gh \
    && rm -rf /var/lib/apt/lists/*

# # Create a non-root user for safer execution
# RUN useradd -m -u 1001 claude

# # Install Claude Code CLI globally
# RUN npm install -g @anthropic-ai/claude-code

# # Configure git + gh auth at startup, then hand off to claude
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

# Repo is mounted here by docker-compose (matches the volume mount)
WORKDIR /app

# # Switch to non-root user
# USER claude

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["tail", "-f", "/dev/null"]
