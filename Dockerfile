FROM gitea/act_runner:latest

# Install Node.js, Git (required for checkout), and Rust toolchain
# build-base and musl-dev are needed for Rust compilation
RUN apk add --no-cache \
    nodejs \
    npm \
    git \
    rust \
    cargo \
    build-base

# Set environment variables for automatic registration
# Note: On Railway, you should provide these via the "Variables" tab
ENV GITEA_RUNNER_NAME="railway-runner"
ENV GITEA_RUNNER_LABELS="ubuntu-latest:host,linux:host,node:host,rust:host"

# Use the official entrypoint but ensure it handles registration
ENTRYPOINT ["/sbin/tini", "--", "/opt/bin/act_runner", "daemon"]
