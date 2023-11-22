# Mattermost deployment computed variables

# source global variables
source vars.sh

# remove old .env file
if [[ -f "../.env" ]]
then
  rm "../.env"
fi

#generate the docker-compose .env file
(
echo "# Mattermost env variables"
echo "# this is an auto generated file. Do not edit"
echo
echo "DOMAIN=$DOMAIN"
echo "PG_DUMP_TRANSFER_PATH=$PG_DUMP_TRANSFER_PATH"
echo "PG_CONTAINER_RESTORE_PATH=$PG_CONTAINER_RESTORE_PATH"
echo "HTTPS_PORT=$HTTPS_PORT"
echo "HTTP_PORT=$HTTP_PORT"
echo "CALLS_PORT=$CALLS_PORT"
echo "MM_CONTAINER_NAME=$MM_CONTAINER_NAME"
echo "PG_CONTAINER_NAME=$PG_CONTAINER_NAME"
echo "PG_IMAGE_TAG=$PG_IMAGE_TAG"
echo "PG_USER=$PG_USER"
echo "PG_PASSWORD=$PG_PASSWORD"
echo "PG_DB=$PG_DB"
echo "MM_IMAGE=$MM_IMAGE"
echo "MM_IMAGE_TAG=$MM_IMAGE_TAG"
echo "MM_BLEVESETTINGS_INDEXDIR=$MM_BLEVESETTINGS_INDEXDIR"
echo "APP_PORT=$APP_PORT"
echo "MM_SQLSETTINGS_DRIVERNAME=$MM_SQLSETTINGS_DRIVERNAME"
echo "MM_SQLSETTINGS_DATASOURCE=$MM_SQLSETTINGS_DATASOURCE"
echo "CHAT_BACKUP_PATH=$CHAT_BACKUP_PATH"
echo "CHAT_DATA_PATH=$CHAT_DATA_PATH"
echo "TZ=$TZ"
) >> ../.env""

echo "Starting containers..."
docker-compose \
    --env-file "${DOCKER_MM_PATH}"/.env \
      -f "${DOCKER_MM_PATH}"/docker-compose.yml up -d

