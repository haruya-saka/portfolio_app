#!/bin/bash
set -ex

echo "=== Container initialization started ==="

echo "Container build completed."

echo "Changing directory to /workspace/backend"
cd ./backend

echo "Checking Gemfile existence..."
if [ ! -f Gemfile ]; then
  echo "Gemfile not found. Creating new Rails app..."
  rails new . -d postgresql
fi

echo "Installing gems..."
bundle install

echo "Removing old server PID file if exists"
rm -f tmp/pids/server.pid

echo "Starting rails server..."
rails server -b 0.0.0.0