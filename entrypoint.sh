#!/bin/bash
set -e

echo "[entrypoint.sh] Starting script"

echo "[entrypoint.sh] Current directory"
ls -la

cd /backend
echo "[entrypoint.sh] Removing old server.pid"
rm -f tmp/pids/server.pid

echo "[entrypoint.sh] Installing gems"
bundle install

echo "[entrypoint.sh] Precompiling assets"
bundle exec rake assets:precompile
bundle exec rake assets:clean

echo "[entrypoint.sh] Running db:migrate"
bundle exec rake db:migrate

echo "[entrypoint.sh] Executing main process: $@"
exec "$@"