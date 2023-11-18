# Mattermost deployment - restore functions

function check_backup() {
  OPTION=$1
  BACKUP_PATH=$2
  CURRENT_BACKUP_DIR=$3
  BASE_BACKUP_DIR_NAME=$4

  if [[ $OPTION == C* ]] || [[ $OPTION == c* ]]
     then
      if [[ -d ${BACKUP_PATH}/${CURRENT_BACKUP_DIR} ]]; then return 0;
      else
        echo "The \"current\" backup directory is missing"
        echo "Please contact the system administrator"
        return 1;
      fi
 fi
  if [[ $1 =~ ^[0-9]+$ ]];
     then
       if [[ -d ${BACKUP_PATH}/${BASE_BACKUP_DIR_NAME}$1 ]]; then return 0;
         echo "The \"${BASE_BACKUP_DIR_NAME}$1\" backup directory is missing"
         echo "Please contact the system administrator"
         return 1;
       fi
  fi
  return 2
}

function list_backups(){
  BACKUP_PATH=$1
  CURRENT_BACKUP_DIR=$2
  BASE_BACKUP_DIR_NAME=$3
  INFO_FILE=$4

  while read -r LINE
  do
    if ! [[ -f "$LINE"/"$INFO_FILE" ]]
      then
        echo "Missing ${INFO_FILE} in $LINE/$INFO_FILE"
        echo "Please contact the system administrator"
        return
    fi
    echo "$LINE"
    cat "$LINE"/"$INFO_FILE"
    echo
  done < <(ls "${BACKUP_PATH}"/*/)
  return 0
}
