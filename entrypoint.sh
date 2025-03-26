#!/bin/bash
set -e

echo "[entrypoint.sh] Starting script"
cd /workspace/backend

# rails new . -d postgresql (Gemfileが無い場合だけRailsアプリを作成)
if [ ! -f Gemfile ]; then
  echo "[entrypoint.sh] Creating new Rails app"
  rails new . -d postgresql
fi

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