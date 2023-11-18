#!/bin/bash

# Mattermost deploy - backup script

# source global variables
source vars.sh

# source backup functions
source backup.fn.sh

echo "Starting backup..."
echo "Stopping Mattermost container..."
docker stop "$MM_CONTAINER_NAME"

# shift the old backup dirs
ROT_OK=rotate_backups \
    "$CHAT_BACKUP_PATH" \
    "$CURRENT_BACKUP_DIR" \
    "$BASE_BACKUP_DIR_NAME" \
    "$MAX_BACKUPS"
if [[ $ROT_OK == 1 ]]; then exit 1; fi

echo "Creating database backup..."
docker exec pg pg_dump -U "$PG_USER" -C -F t "$PG_DB">"${CHAT_BACKUP_PATH}"/"${CURRENT_BACKUP_DIR}"

echo "Creating Mattermost settings and data backup archive..."
tar czf "${CHAT_BACKUP_PATH}"/"${CHAT_BACKUP_FILE_NAME}"/"${CURRENT_BACKUP_DIR}" "${VOLUMES_MATERMOST_PATH}"

CREATE_OK=create_info \
    "${CHAT_BACKUP_PATH}" \
    "${INFO_FILE}" \
    "${CHAT_BACKUP_FILE_NAME}" \
    "${DB_BACKUP_FILE_NAME}"

if [[ ${CREATE_OK} == 1 ]]; then exit 1; fi

echo "Backup successful"
