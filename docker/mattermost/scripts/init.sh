# Mattermost deployment computed variables

# source global variables
source vars.sh

# accept a command line arg for the .env file path
# the default (in no arg is present) is "../.env"
ENV_PATH=$( [[ -z $1 ]] && echo "../.env" || echo "$1" )

# remove old .env file
if [[ -f $ENV_PATH ]];
then
  rm "../.env"
fi

#generate the docker-compose .env file
(
echo "# Mattermost env variables"
echo "# this is an auto generated file. Do not edit"
echo
echo "DOMAIN=$DOMAIN"
echo "PG_DATA_PATH=$PG_DATA_PATH"
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
echo "MM_CONFIG_PATH=$MM_CONFIG_PATH"
echo "MM_DATA_PATH=$MM_DATA_PATH"
echo "MM_LOGS_PATH=$MM_LOGS_PATH"
echo "MM_PLUGINS_PATH=$MM_PLUGINS_PATH"
echo "MM_CLIENT_PLUGINS_PATH=$MM_CLIENT_PLUGINS_PATH"
echo "MM_BLEVE_INDEXES_PATH=$MM_BLEVE_INDEXES_PATH"
echo "MM_SQLSETTINGS_DRIVERNAME=$MM_SQLSETTINGS_DRIVERNAME"
echo "MM_SQLSETTINGS_DATASOURCE=$MM_SQLSETTINGS_DATASOURCE"
echo "MM_BLEVESETTINGS_INDEXDIR="
echo "CHAT_BACKUP_PATH=$CHAT_BACKUP_PATH"
echo "CHAT_DATA_PATH=$CHAT_DATA_PATH"
echo "TZ=$TZ"
) >> ../.env""

echo "Starting containers..."
docker-compose \
    --env-file "${DOCKER_MM_PATH}"/.env \
      -f "${DOCKER_MM_PATH}"/docker-compose.yml up -d

