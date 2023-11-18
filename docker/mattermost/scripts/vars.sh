#!/bin/bash
# Mattermost deployment computed variables

# Collect all Mattermost variables
echo "Reading global variables (.env)..."

# for testing purpose the .env file path can be supplied as a command line argument
ENV_PATH=$([[ -z $1 ]] && echo "../.env" || echo "$1/.env")

# shellcheck source=../.env
source "$ENV_PATH" || echo "ERROR: Unable to read .env file in: ${ENV_PATH}" && exit 1

if [ -z "$USR" ]
then
    echo "Couldn't source $ENV_PATH. Exiting."
    exit
fi

# shellcheck disable=SC2034
MM_DIR_LIST=(
	"$VOLUMES_MATERMOST_PATH"
	"$VOLUMES_MATERMOST_PATH/client"
	"$MM_CONFIG_PATH"
    "$MM_DATA_PATH"
    "$MM_LOGS_PATH"
    "$MM_PLUGINS_PATH"
    "$MM_CLIENT_PLUGINS_PATH"
    "$MM_BLEVE_INDEXES_PATH"
	"$PG_DATA_PATH"
)