#!/bin/sh

set -e  # Exit on any error

echo "Logging into local registry..."
echo "${REGISTRY_PASSWORD}" | docker login --username "${REGISTRY_USER}" --password-stdin "${REGISTRY_URL}"

DOCKERFILE_PATH="/build-context/Dockerfile.agent"
DOCKERFILE_HASH=$(sha256sum "${DOCKERFILE_PATH}" | awk '{print $1}')
EXISTING_HASH=$(docker image inspect "${JENKINS_DOCKER_AGENT_IMAGE_PATH}" --format '{{ index .Config.Labels "dockerfile-hash" }}' 2>/dev/null || echo 'none')

if [ "$DOCKERFILE_HASH" != "$EXISTING_HASH" ]; then
    echo '🔄 Dockerfile changed! Rebuilding and pushing the custom docker agent image...'
    docker build --label dockerfile-hash="$DOCKERFILE_HASH" -t "${JENKINS_DOCKER_AGENT_IMAGE_PATH}" -f "${DOCKERFILE_PATH}" /build-context &&
    docker push "${JENKINS_DOCKER_AGENT_IMAGE_PATH}"

    # When a new image is pushed, the old one will exist in the registry with the '<none>' tag.
    # The following will remove old untagged images
    echo "🗑️ Cleaning up old untagged images..."
    docker image prune -f
else
    echo '✅ Image is up-to-date, skipping build.'
fi

docker logout  "${REGISTRY_URL}"

docker images
echo "Done."
