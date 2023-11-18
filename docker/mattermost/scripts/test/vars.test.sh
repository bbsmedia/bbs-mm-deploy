#!/bin/bash

echo "Loading test vars values"

source vars.sh "../../"

if [ "$HOME_DIR" != "/home" ]
  then
    echo "ERROR: Wrong var value for: HOME_DIR"
    exit
fi

# $BASE_DIR
if [ "$BASE_DIR" != "/home/webadmin" ]
  then
    echo "ERROR: Wrong var value for: BASE_DIR: $BASE_DIR"
    exit
fi

# $DOCKER_MM_DIR
if [ "$DOCKER_MM_DIR" != "mattermost" ]
  then
    echo "ERROR: Wrong var value for: DOCKER_MM_DIR: $DOCKER_MM_DIR"
    exit
fi

# $DOCKER_MM_DIR
if [ "$DOCKER_MM_DIR" != "mattermost" ]
  then
    echo "ERROR: Wrong var value for: DOCKER_MM_DIR: $DOCKER_MM_DIR"
    exit
fi

# $DOCKER_DIR
if [ "$DOCKER_DIR" != "docker" ]
  then
    echo "ERROR: Wrong var value for: DOCKER_DIR: $DOCKER_DIR"
    exit
fi

# $VOLUMES_DIR
if [ "$VOLUMES_DIR" != "volumes" ]
  then
    echo "ERROR: Wrong var value for: VOLUMES_DIR: $VOLUMES_DIR"
    exit
fi

# $VOLUMES_MM_DIR
if [ "$VOLUMES_MM_DIR" != "mattermost" ]
  then
    echo "ERROR: Wrong var value for: VOLUMES_MM_DIR: $VOLUMES_MM_DIR"
    exit
fi

# $CHAT_BACKUP_DIR
if [ "$CHAT_BACKUP_DIR" != "chat_backup" ]
  then
    echo "ERROR: Wrong var value for: CHAT_BACKUP_DIR: $CHAT_BACKUP_DIR"
    exit
fi

# $CHAT_DATA_DIR
if [ "$CHAT_DATA_DIR" != "chat_data" ]
  then
    echo "ERROR: Wrong var value for: CHAT_DATA_DIR: $CHAT_DATA_DIR"
    exit
fi

 # $PG_DATA_DIR
if [ "$PG_DATA_DIR" != "pg_data" ]
  then
    echo "ERROR: Wrong var value for: PG_DATA_DIR: $PG_DATA_DIR"
    exit
fi

# $MM_CONFIG_PATH
if [ "$MM_CONFIG_PATH" != "/home/webadmin/docker/mattermost/volumes/mattermost/config" ]
  then
    echo "ERROR: Wrong var value for: MM_CONFIG_PATH: $MM_CONFIG_PATH"
    exit
fi

# $MM_DATA_PATH
if [ "$MM_DATA_PATH" != "/home/webadmin/docker/mattermost/volumes/mattermost/data" ]
  then
    echo "ERROR: Wrong var value for: MM_DATA_PATH: $MM_DATA_PATH"
    exit
fi

# $MM_LOGS_PATH
if [ "$MM_LOGS_PATH" != "/home/webadmin/docker/mattermost/volumes/mattermost/logs" ]
  then
    echo "ERROR: Wrong var value for: MM_LOGS_PATH: $MM_LOGS_PATH"
    exit
fi

# $MM_PLUGINS_PATH
if [ "$MM_PLUGINS_PATH" != "/home/webadmin/docker/mattermost/volumes/mattermost/plugins" ]
  then
    echo "ERROR: Wrong var value for: MM_PLUGINS_PATH: $MM_PLUGINS_PATH"
    exit
fi

# $MM_CLIENT_PLUGINS_PATH
if [ "$MM_CLIENT_PLUGINS_PATH" != "/home/webadmin/docker/mattermost/volumes/mattermost/client/plugins" ]
  then
    echo "ERROR: Wrong var value for: MM_CLIENT_PLUGINS_PATH: $MM_CLIENT_PLUGINS_PATH"
    exit
fi

# $MM_BLEVE_INDEXES_PATH
if [ "$MM_BLEVE_INDEXES_PATH" != "/home/webadmin/docker/mattermost/volumes/mattermost/bleve-indexes" ]
  then
    echo "ERROR: Wrong var value for: MM_BLEVE_INDEXES_PATH: $MM_BLEVE_INDEXES_PATH"
    exit
fi

# $MM_BLEVE_INDEXES_PATH
if [ "$MM_CONTAINER_NAME" != "mm" ]
  then
    echo "ERROR: Wrong var value for: MM_BLEVE_INDEXES_PATH: $MM_BLEVE_INDEXES_PATH"
    exit
fi
# $PG_IMAGE_TAG
if [ "$PG_IMAGE_TAG" != "13-alpine" ]
  then
    echo "ERROR: Wrong var value for: PG_IMAGE_TAG: $PG_IMAGE_TAG"
    exit
fi

# $PG_IMAGE_TAG
if [ "$TZ" != "UTC" ]
  then
    echo "ERROR: Wrong var value for: TZ: $TZ"
    exit
fi

# $PG_IMAGE_TAG
if [ "$TZ" != "UTC" ]
  then
    echo "ERROR: Wrong var value for: TZ: $TZ"
    exit
fi

echo "SUCCESS: Tests passed ok"
