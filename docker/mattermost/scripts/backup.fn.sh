function rotate_backups(){

  BACKUP_PATH=$1
  CURRENT_BACKUP_DIR=$2
  BASE_BACKUP_DIR_NAME=$3
  MAX_BACKUPS=$(($4))

  if ! [ -d "$BACKUP_PATH" ]
    then
      echo "No directory:$BACKUP_PATH found. Exiting"
      return 1
  fi

  # if the maximum number of backup has been reached,
  # delete the oldest
  # shellcheck disable=SC2005
  echo
  if [ -d  "${BASE_BACKUP_DIR_NAME}${MAX_BACKUPS}" ]
    then
      echo "Deleting backup${MAX_BACKUPS}..."
      rm -rf "$BASE_BACKUP_DIR_NAME$MAX_BACKUPS"
  fi

  # increment the backup number af all existing backups
  for (( i=(MAX_BACKUPS-1); i>0; i-- ))
  do
     if [ -d  "$BASE_BACKUP_DIR_NAME$i" ]
        then
          mv "$BASE_BACKUP_DIR_NAME$i" "$BASE_BACKUP_DIR_NAME$((i+1))"
     fi
  done

  # finally rename the previous current backup
  # as backup1
  # echo $( [[ -d "$CURRENT_BACKUP_DIR" ]] && echo "!!!!!!ESTE" || echo )
  if [[ -d "$CURRENT_BACKUP_DIR" ]]
    then mv "$CURRENT_BACKUP_DIR" "$BASE_BACKUP_DIR_NAME"1
    else mkdir -p "$CURRENT_BACKUP_DIR"
  fi
}

function create_info(){
  #collect args
  BACKUP_PATH=$1
  INFO_FILE=$2
  CHAT_BACKUP=$3
  DB_BACKUP=$4

  if ! [[ -f "${BACKUP_PATH}/${CHAT_BACKUP}" ]] ||
     ! [[ -f "${BACKUP_PATH}/${DB_BACKUP}" ]]
  then
    echo "One of ${CHAT_BACKUP} or ${DB_BACKUP} backup files is missing. Exiting."
    return 1
  fi

  MM_BACKUP_SIZE=$(du -sh "${BACKUP_PATH}/${CHAT_BACKUP}" | awk '{print $1}')
  DB_BACKUP_SIZE=$(du -sh "${BACKUP_PATH}/${DB_BACKUP}" | awk '{print $1}')

  # create info file
  touch "${BACKUP_PATH}/${INFO_FILE}"

  # populate it with data
  {
    echo "# Mattermost backup session"
    echo BACKUP_DATE="$(date +'%A %I:%M%p %d-%m-%Y')"
    echo "MM_BACKUP_SIZE=$MM_BACKUP_SIZE"
    echo "DB_BACKUP_SIZE=$DB_BACKUP_SIZE"
  }>>"${BACKUP_PATH}/${INFO_FILE}"
}