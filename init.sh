#!/usr/bin/env bash
set -e

# Start the SSH service in the background
service ssh start

# Start the Uvicorn server in the foreground.
# The script will wait here until uvicorn exits, keeping the container running.
uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}