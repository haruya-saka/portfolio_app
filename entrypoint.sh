#!/bin/bash
set -e

echo "[entrypoint.sh] Starting script"

# Remove a potentially pre-existing server.pid for Rails.
echo "[entrypoint.sh] Removing old server.pid"
rm -f /sample_rails/tmp/pids/server.pid

# Debugging: List files in the working directory
echo "[entrypoint.sh] Listing files in working directory:"
ls -la /sample_rails

# Then exec the container's main process.
echo "[entrypoint.sh] Executing main process: $@"
exec "$@"