#!/bin/sh

set -e  # Exit on any error

echo "Logging into local registry..."
docker login -u "${REGISTRY_USER}" -p "${REGISTRY_PASSWORD}" "${REGISTRY_URL}"

echo "Building agent image..."
docker build -t "${REGISTRY_URL}/jenkins_agent:latest" -f /build-context/Dockerfile.agent /build-context

echo "Pushing agent image to local registry..."
docker push "${REGISTRY_URL}/jenkins_agent:latest"

docker images
echo "Done."
