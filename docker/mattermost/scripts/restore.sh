#!/bin/bash

# Mattermost deployment - restore script

# source global variables
source vars.sh

echo "Mattermost restore utility"
echo "© 2023 - M-Tag.io"
echo " - to restore the last (current) backup press \"c\""
echo " - to list the available backups press \"l\""
echo " - to restore a specific backup the corresponding"
echo "   number from the backup list (ex: 2 for backup2)"
read -p "Enter an option: " -n 1 -r
echo

# if no registered option has been selected just exit gracefully
if !  [[ $REPLY =~ ^[LlcC]$ || $REPLY =~ ^[0-9]+$ ]] ;
  then
    echo "Un-registered option: $REPLY. Restore aborted"
    exit 0;
fi

BACKUP_OK=cheeck_backup\
  $REPLY \
  "$BACKUP_PATH" \
  "$CURRENT_BACKUP_DIR" \
  "$BASE_BACKUP_DIR_NAME"

if [[ $BACKUP_OK == 1 ]]; then exit 1; fi

if [[ $BACKUP_OK == 2 ]]
  then
    echo "Unregistered option entered."
    echo "Restore aborted."
    exit 0
fi

if [[ $REPLY =~ ^[Ll]$ ]]
  then LIST_OK=list_backups \
         "${BACKUP_PATH}" \
         "${CURRENT_BACKUP_DIR}" \
         "${BASE_BACKUP_DIR_NAME}" \
         "${INFO_FILE}"
   exit $((LIST_OK))
fi

if [[ $REPLY =~ ^[cC]$ ]]
  then BACKUP_DIR="${CURRENT_BACKUP_DIR}"
  else BACKUP_DIR="${BASE_BACKUP_DIR_NAME}${REPLY}"
fi
echo "Stopping containers..."
docker stop "$MM_CONTAINER_NAME"
docker stop "$PG_CONTAINER_NAME"

echo "Cleaning up old Mattermost data ($VOLUMES_MM_PATH)..."
rm -rf "$VOLUMES_MM_PATH"

echo "Extracting backup data..."
tar -xvf "${BACKUP_PATH}/${BACKUP_DIR}/${CHAT_BACKUP_FILE_NAME}" -C "$BASE_DIR"

echo "Copying the database dump file to the transfer location..."
cp "${BACKUP_PATH}/${BACKUP_DIR}/${DB_BACKUP_FILE_NAME}" "$PG_DUMP_TRANSFER_PATH"

echo "Restoring database backup..."
docker exec -i "$PG_CONTAINER_NAME" pg_restore --clean -U "${PG_USER}" \
  -d "${PG_DB}" "${PG_CONTAINER_RESTORE_PATH}"/"${DB_BACKUP_FILE_NAME}"

echo "Restarting Mattermost..."
docker restart "$MM_CONTAINER_NAME"

echo "Restore operation successful."
echo "Please wait for a few moments for the container to spin up."

