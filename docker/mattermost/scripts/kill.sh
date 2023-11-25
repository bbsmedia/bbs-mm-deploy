#!/bin/bash

# source global variables
source vars.sh

set -e

function exitFn(){
  MSG=$1
  E_CODE=$2
  echo "ERROR: $1"
  exit $(("$E_CODE")) || 1
}

echo "Mattermost full reset utility"
echo "© 2023 - M-Tag.io"
echo "WARNING! This script is going to wipe out all data"
echo "in Mattermost, including files directory, configurations,"
echo "chats, boards, users and configuration settings"
read -p "Are you sure you want to proceed ? " -n 1 -r
echo

if ! [[ $REPLY =~ ^[Yy]$ ]]
  then
    echo "Operation aborted"
    exit 0
fi

echo "Removing ${MM_CONTAINER_NAME} container..."
docker rm -f "${MM_CONTAINER_NAME}" || \
  exitFn "Removing ${MM_CONTAINER_NAME} container failed. Aborting"

echo "Removing ${DB_CONTAINER_NAME} container..."
docker rm -f "${PG_CONTAINER_NAME}" || \
  exitFn "Removing ${DB_CONTAINER_NAME} container failed. Aborting"


echo "Cleaning up all chat files and configurations" \
echo "in $VOLUMES_MM_PATH"
rm -rf "$VOLUMES_MM_PATH" || \
  exitFn "Removing ${DB_CONTAINER_NAME} failed. Aborting"


echo "Cleaning up all database data in $PG_DATA_PATH"
rm -rf "$PG_DATA_PATH"

echo "Re-creating directories..."
mkdir "${MM_DIR_LIST[@]}"
    
echo "Granting ownership to docker process..."
chown -R 2000:2000 "$VOLUMES_MM_PATH"
chown -R 2000:2000 "$PG_DATA_PATH"

echo "Killer succeeded. Targets eliminated."

