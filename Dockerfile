FROM node:20-slim

# Create a non-root user for safer execution
RUN useradd -m -u 1001 claude

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

# Set the working directory
WORKDIR /workspace

# Switch to non-root user
USER claude

ENTRYPOINT ["claude"]