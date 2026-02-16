FROM gitea/act_runner:latest

# Install Node.js, Git (required for checkout), and Rust toolchain
# build-base and musl-dev are needed for Rust compilation
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    rust \
    cargo \
    build-base \
    bash

# Set environment variables for automatic registration
# Note: On Railway, you should provide these via the "Variables" tab
ENV GITEA_RUNNER_NAME="railway-runner"
ENV GITEA_RUNNER_LABELS="ubuntu-latest:host,linux:host,node:host,rust:host"

# Use the correct binary location
# The official image uses /usr/local/bin/act_runner
ENTRYPOINT ["act_runner", "daemon"]
