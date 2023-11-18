# Mattermost deployment computed variables

# source global variables
source vars.sh

echo "Starting containers..."
docker-compose \
    --env-file "${DOCKER_MM_PATH}"/base.env \
    --env-file "${DOCKER_MM_PATH}"/.env \
      -f "${DOCKER_MM_PATH}"/docker-compose.yml up -d

