#!/bin/bash

# Mattermost deploy - backup script

# source global variables
source vars.sh

set -e

function exitFn(){
  MSG=$1
  E_CODE=$2
  echo "ERROR: $1"
  exit $(("$E_CODE")) || 1
}

echo "Starting backup..."
echo "Stopping Mattermost container..."
docker stop "$MM_CONTAINER_NAME"

# **** ROTATE BACKUPS *****
# shift the old backup dirs

# check the existence of the base backup path
if ! [ -d "${CHAT_BACKUP_PATH}" ]
  then exitFn "No directory:${CHAT_BACKUP_PATH} found. Exiting"
fi

# if the maximum number of backup has been reached,
# delete the oldest
if [ -d  "${CHAT_BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}${MAX_BACKUPS}" ]
  then
    echo "Deleting backup${MAX_BACKUPS}..."
    rm -rf "${CHAT_BACKUP_PATH:?}/${BASE_BACKUP_DIR_NAME}${MAX_BACKUPS}"
fi

# increment the backup number af all existing backups
for (( i=(MAX_BACKUPS-1); i>0; i-- ))
  do
     if [ -d  "${CHAT_BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}${i}" ]
        then
          mv "${CHAT_BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}${i}" "${CHAT_BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}$((i+1))"
     fi
  done

# if a current backup dir exists rename it as backup1
# else create it
if [[ -d "${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}" ]]
  then
    echo "Renaming ${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR} to ${CHAT_BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}1"
    mv "${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}" "${CHAT_BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}"1 || \
    exitFn "Unable to rename ${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR} to ${CHAT_BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}1"
fi

echo "Creating the current backup dir in: ${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}"
mkdir -p "${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}" || \
  exitFn "Unable to create ${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}"

# **** CREATE ACTUAL BACKUPS *****
# for both database and Mattermost

CHAT_ARCHIVE_PATH="${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}/${CHAT_BACKUP_FILE_NAME}"
DB_ARCHIVE_PATH="${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}/${DB_BACKUP_FILE_NAME}"

echo "Creating Mattermost settings and data backup archive..."
tar cvzf "${CHAT_ARCHIVE_PATH}"  -C "${VOLUMES_MM_PATH}" . || \
  exitFn "Unable to create ${CHAT_BACKUP_FILE_NAME} in ${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}"

echo "Creating database backup..."
docker exec pg pg_dump -U "${PG_USER}" -C -F t "$PG_DB">"${DB_ARCHIVE_PATH}" || \
  exitFn "Unable to create dump database to ${DB_ARCHIVE_PATH}"


# **** CREATE INFO FILE *****
#

if ! [[ -f "${CHAT_ARCHIVE_PATH}" ]] ||
   ! [[ -f "${DB_ARCHIVE_PATH}" ]]
then
  exitFn "One of ${CHAT_BACKUP_FILE_NAME} or ${DB_BACKUP_FILE_NAME} backup files is missing. Exiting."
fi

MM_BACKUP_SIZE=$(du -sh "${CHAT_ARCHIVE_PATH}" | awk '{print $1}')
DB_BACKUP_SIZE=$(du -sh "${DB_ARCHIVE_PATH}" | awk '{print $1}')

# create info file
touch "${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}/${INFO_FILE}" || \
  exitFn "Unable to create the ${INFO_FILE} file"

# populate it with data
INFO_CONTENT=$(
  echo "# Mattermost backup session"
  echo BACKUP_DATE="$(date +'%A %I:%M%p %d-%m-%Y')"
  echo "MM_BACKUP_SIZE=$MM_BACKUP_SIZE"
  echo "DB_BACKUP_SIZE=$DB_BACKUP_SIZE"
)

echo "${INFO_CONTENT}">"${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}/${INFO_FILE}" || \
  exitFn "Unable to write into the ${INFO_FILE} file"

echo "********* BACKUP SUMMARY: *********"
cat "${CHAT_BACKUP_PATH}/${CURRENT_BACKUP_DIR}/${INFO_FILE}"
echo "***********************************"

echo "Restarting Mattermost container..."
docker start "$MM_CONTAINER_NAME"

trap exitFn ERR

echo "Backup successful"