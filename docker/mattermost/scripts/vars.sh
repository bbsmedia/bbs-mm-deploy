#!/bin/bash
# Mattermost deployment computed variables

# **** BASE VARIABLES ****
# this is where changes should occur

# Domain of service
DOMAIN="chat.bbs.media"

# Delegate user
USR="webadmin"

# Home directory
HOME_DIR="/home"

DOCKER_MM_DIR="mattermost"
DOCKER_DIR="docker"
VOLUMES_DIR="volumes"
VOLUMES_MM_DIR="mattermost"
CHAT_BACKUP_DIR="chat_backup"
CHAT_DATA_DIR="chat_data"
PG_DATA_DIR="pg_data"
PG_DUMP_TRANSFER_PATH="/tmp"
PG_CONTAINER_RESTORE_PATH="/tmp"

CURRENT_BACKUP_DIR="current"
BASE_BACKUP_DIR_NAME="backup"
MAX_BACKUPS=5
INFO_FILE="info"


# File names
CHAT_BACKUP_FILE_NAME="mm.backup"
DB_BACKUP_FILE_NAME="mm.sql"

## Exposed ports to the host. Inside the container 80, 443 and 8443 will be used
HTTPS_PORT=443
HTTP_PORT=80
CALLS_PORT=8443

# Container names
MM_CONTAINER_NAME="mm"
PG_CONTAINER_NAME="pg"

# Postgres container data
PG_IMAGE_TAG="13-alpine"
PG_USER="mmUser"
PG_PASSWORD="23df48(9d_osj)knHGG49*"
PG_DB="mattermost"

## This will be 'mattermost-enterprise-edition' or 'mattermost-team-edition' based on the version of Mattermost you're installing.
MM_IMAGE="mattermost-enterprise-edition"
MM_IMAGE_TAG="latest"

# Timezone
# (See timezone chapter in the docs)
TZ="UTC"

## Bleve index (inside the container)
MM_BLEVESETTINGS_INDEXDIR="/mattermost/bleve-indexes"

# Mattermost public facing port
APP_PORT=8065

## Below one can find necessary settings to spin up the Mattermost container
MM_SQLSETTINGS_DRIVERNAME="postgres"
MM_SQLSETTINGS_DATASOURCE="postgres://mmuser:mmuser_password@postgres:5432/mattermost?sslmode=disable&connect_timeout=10"

# **** COMPUTED VARIABLES ****
# this section should not be changed
# while it depends on the previous one

# Dir names
BASE_DIR="$HOME_DIR/$USR"
DOCKER_PATH="$BASE_DIR/$DOCKER_DIR"
DOCKER_MM_PATH="$DOCKER_PATH/$DOCKER_MM_DIR"
VOLUMES_PATH="$DOCKER_MM_PATH/$VOLUMES_DIR"
VOLUMES_MM_PATH="$VOLUMES_PATH/$VOLUMES_MM_DIR"
CHAT_BACKUP_PATH="$BASE_DIR/$CHAT_BACKUP_DIR"
CHAT_DATA_PATH="$BASE_DIR/$CHAT_DATA_DIR"
PG_DATA_PATH="$VOLUMES_PATH/$PG_DATA_DIR"

MM_CONFIG_PATH="$VOLUMES_MM_PATH/config"
MM_DATA_PATH="$VOLUMES_MM_PATH/data"
MM_LOGS_PATH="$VOLUMES_MM_PATH/logs"
MM_PLUGINS_PATH="$VOLUMES_MM_PATH/plugins"
MM_CLIENT_PLUGINS_PATH="$VOLUMES_MM_PATH/client/plugins"
MM_BLEVE_INDEXES_PATH="$VOLUMES_MM_PATH/bleve-indexes"

MM_DIR_LIST=(
	"$VOLUMES_MM_PATH"
	"$VOLUMES_MM_PATH/client"
	"$MM_CONFIG_PATH"
  "$MM_DATA_PATH"
  "$MM_LOGS_PATH"
  "$MM_PLUGINS_PATH"
  "$MM_CLIENT_PLUGINS_PATH"
  "$MM_BLEVE_INDEXES_PATH"
	"$PG_DATA_PATH"
)