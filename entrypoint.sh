#!/bin/bash
set -e

echo "[entrypoint.sh] Starting script"

# Then exec the container's main process.
echo "[entrypoint.sh] Executing main process: $@"
exec "$@"