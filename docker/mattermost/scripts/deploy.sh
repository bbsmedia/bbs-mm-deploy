#!/bin/bash

# Mattermost deployment - restore script
set -e
# source global variables
source vars.sh

function exitFn(){
  MSG=$1
  E_CODE=$2
  echo "ERROR: $1"
  exit $(("$E_CODE")) || 1
}

CURRENT=${CURRENT_BACKUP_DIR}

echo "Mattermost restore utility"
echo "© 2023 - M-Tag.io"
echo " - to restore the last (current) backup press \"c\""
echo " - to list the available backups press \"l\""
echo " - to restore a specific backup the corresponding"
echo "   number from the backup list (ex: 2 for backup2)"
read -p "Enter an option: " -n 1 -r
echo

# **** CHECK BACKUPS *****
# shift the old backup dirs

# if no registered option has been selected just exit gracefully
if !  [[ $REPLY =~ ^[LlcC]$ || $REPLY =~ ^[0-9]+$ ]] ;
  then
    echo "Un-registered option: $REPLY. Restore aborted"
    exit 0;
fi

if [[ $REPLY =~ ^[cC]$ ]]
     then
      if ! [[ -d ${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR} ]];
      then
        exitFn "The ${CURRENT_BACKUP_DIR} backup directory is missing. Aborting."
      fi
fi

if [[ $REPLY =~ ^[0-9]+$ ]];
   then
     if ! [[ -d "${CHAT_BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}${REPLY}" ]]
      then
       exitFn "The \"${BASE_BACKUP_DIR_NAME}${REPLY}\" backup directory is missing. \
        Use the l option to list available backups."
     fi
   else
     CURRENT="${BASE_BACKUP_DIR_NAME}${REPLY}"
fi

if [[ $REPLY =~ ^[Ll]$ ]]
  then
    while read -r LINE
      do
        if ! [[ -f "${CHAT_BACKUP_PATH}/${LINE}/$INFO_FILE" ]]
          then
            echo "Missing ${INFO_FILE} in $LINE"
        fi
        echo "$LINE"
        cat "${CHAT_BACKUP_PATH}/$LINE/$INFO_FILE"
      done < <(ls "${CHAT_BACKUP_PATH}"/)
      echo
      echo "No restore actions initiated"
      exit 0
fi

if [[ $REPLY =~ ^[cC]$ ]]
  then CURRENT="${CURRENT_BACKUP_DIR}"
  else CURRENT="${BASE_BACKUP_DIR_NAME}${REPLY}"
fi
echo "Stopping containers..."
docker stop "$MM_CONTAINER_NAME"

echo "Cleaning up old Mattermost data ($VOLUMES_MM_PATH)..."
rm -rf "${VOLUMES_MM_PATH}"
mkdir -p "${VOLUMES_MM_PATH}"

echo "Extracting backup data..."
tar  -xzvf "${CHAT_BACKUP_PATH}/${CURRENT}/${CHAT_BACKUP_FILE_NAME}" -C "${VOLUMES_MM_PATH}"

echo "Granting ownership to docker process..."
chown -R 2000:2000 "$VOLUMES_MM_PATH"

echo "Copying the database dump file to the transfer location..."
cp "${CHAT_BACKUP_PATH}/${CURRENT}/${DB_BACKUP_FILE_NAME}" "$PG_DUMP_TRANSFER_PATH"

echo "$PG_CONTAINER_NAME"

echo "Restoring database backup..."
docker exec -i "$PG_CONTAINER_NAME" pg_restore -U "${PG_USER}" \
  -d "${PG_DB}" "${PG_CONTAINER_RESTORE_PATH}/${DB_BACKUP_FILE_NAME}"

echo "Restarting Mattermost..."
docker-compose \
    --env-file "${DOCKER_MM_PATH}"/.env \
      -f "${DOCKER_MM_PATH}"/docker-compose.yml up -d


echo "Restore operation successful."
echo "Please wait for a few moments for the container to spin up."

