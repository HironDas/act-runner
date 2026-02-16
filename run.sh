#!/bin/bash

# If the .runner file does not exist, register the runner
if [ ! -f .runner ]; then
  echo "Registering runner..."
  act_runner register \
    --instance "${GITEA_INSTANCE_URL}" \
    --token "${GITEA_RUNNER_REGISTRATION_TOKEN}" \
    --name "${GITEA_RUNNER_NAME}" \
    --labels "${GITEA_RUNNER_LABELS}" \
    --no-interactive
fi

# Start the daemon
echo "Starting daemon..."
exec act_runner daemon
