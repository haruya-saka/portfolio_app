#!/bin/bash
set -e

echo "[entrypoint.sh] starting script"

# Remove a potentially pre-existing server.pid for Rails.
echo "[entrypoint.sh] removing old server.pid"
rm -f /sample_rails/tmp/pids/server.pid

# Then exec the container's main process.
echo "[entrypoint.sh] executing main process"
exec "$@"