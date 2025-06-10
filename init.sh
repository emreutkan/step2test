#!/usr/bin/env bash
set -e

# Start SSH server in background
service ssh start

# Start FastAPI via Uvicorn (module path reflects your folder structure)
exec uvicorn app.main:app --host 0.0.0.0 --port ${PORT:-8000}