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

WORKDIR /data

# Copy the startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Set defaults (override these in Railway Variables)
ENV GITEA_RUNNER_NAME="railway-runner"
ENV GITEA_RUNNER_LABELS="ubuntu-latest:host,node:host,rust:host"

ENTRYPOINT ["/run.sh"]