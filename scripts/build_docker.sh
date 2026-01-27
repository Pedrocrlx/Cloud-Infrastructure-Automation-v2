#!/bin/bash
set -euo pipefail

# Configuration
IMAGE_NAME="saas-app"
IMAGE_TAG="local"

echo "[INFO] Starting Docker build process..."
echo "[INFO] Image: ${IMAGE_NAME}:${IMAGE_TAG}"

# Build the image
# We use -f app/Dockerfile because the context is the root, but file is inside app/
docker build -t "${IMAGE_NAME}:${IMAGE_TAG}" -f app/Dockerfile app/

echo "[INFO] Build completed successfully."
echo "[INFO] You can verify images using 'docker images'."