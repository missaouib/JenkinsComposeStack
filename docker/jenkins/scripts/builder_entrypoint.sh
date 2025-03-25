#!/bin/sh

set -e  # Exit on any error

echo "Logging into local registry..."
echo "${REGISTRY_PASSWORD}" | docker login --username "${REGISTRY_USER}" --password-stdin "${REGISTRY_URL}"

echo "Building agent image..."
docker build -t "${JENKINS_DOCKER_AGENT_IMAGE_PATH}" -f /build-context/Dockerfile.agent /build-context

echo "Pushing agent image to local registry..."
docker push "${JENKINS_DOCKER_AGENT_IMAGE_PATH}"

docker images
echo "Done."
