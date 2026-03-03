#!/bin/bash

# 1. Registration Logic (unchanged)
if [ ! -f .runner ]; then
  echo "Registering runner..."
  act_runner register \
    --instance "${GITEA_INSTANCE_URL}" \
    --token "${GITEA_RUNNER_REGISTRATION_TOKEN}" \
    --name "${GITEA_RUNNER_NAME}" \
    --labels "${GITEA_RUNNER_LABELS}" \
    --no-interactive
fi

# 2. Start the daemon with the --once flag
# This will wait for ONE job, execute it, and then the process will exit.
echo "Starting daemon (Ephemeral Mode)..."
act_runner daemon --once

echo "Job finished. Service shutting down automatically."
exit 0