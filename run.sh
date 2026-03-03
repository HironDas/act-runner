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

# 3. Shutdown Logic
# Once the runner exits, we tell Railway to stop this service instance.
if [ -n "$RAILWAY_TOKEN" ]; then
  echo "Job finished. Signaling Railway to stop service..."
  
  # We use a curl command to the Railway GraphQL API to 'down' the service
  # This is more reliable than the CLI inside a container
  curl --request POST \
    --url https://backboard.railway.app/graphql/v2 \
    --header "Project-Access-Toke: $RAILWAY_TOKEN" \
    --header "Content-Type: application/json" \
    --data "{
      \"query\": \"mutation serviceInstanceStop(\$serviceId: String!) { serviceInstanceStop(serviceId: \$serviceId) }\",
      \"variables\": { \"serviceId\": \"$RAILWAY_SERVICE_ID\" }
    }"
else
  echo "RAILWAY_TOKEN not found. Manual shutdown required or service will restart."
fi
