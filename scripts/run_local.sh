#!/bin/bash
set -euo pipefail

IMAGE_NAME="saas-app"
IMAGE_TAG="local"
PORT=5000

echo "[INFO] Running application container..."
echo "[INFO] Mapping port ${PORT} to container port 5000"

# Stop existing container if running (ignore error if not found)
docker rm -f saas-app-container 2>/dev/null || true

# Run new container
docker run -d \
  --name saas-app-container \
  -p "${PORT}:5000" \
  -e APP_VERSION="v1.0.0-local" \
  "${IMAGE_NAME}:${IMAGE_TAG}"

echo "[INFO] Container is running."
echo "[INFO] Access http://localhost:${PORT} to test."