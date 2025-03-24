#!/bin/sh

set -e  # Exit on any error

echo "Logging into local registry..."
docker login -u "${REGISTRY_USER}" -p "${REGISTRY_PASSWORD}" "${REGISTRY_URL}"

echo "Building agent image..."
docker build -t "${JENKINS_AGENT_IMAGE_PATH}" -f /build-context/Dockerfile.agent /build-context

echo "Pushing agent image to local registry..."
docker push "${JENKINS_AGENT_IMAGE_PATH}"

docker images
echo "Done."
