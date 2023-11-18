#!/bin/bash

TEST_ROOT="/tmp/mm-test"
INFO_FILE="info"
CHAT_BACKUP="mm-backup"
DB_BACKUP="mm.sql"
CHAT_BACKUP_SIZE=50000
DB_BACKUP_SIZE=30000


source bacup.fn.sh

function cleanUp() {
  # shellcheck disable=SC2115
  rm -rf "${TEST_ROOT}"
}

if [ -f "$TEST_ROOT" ]
then
  # cleanup old test data files and dirs
  # shellcheck disable=SC2115
  rm -rf "${TEST_ROOT}"
fi

# re-crate the test working directory
# shellcheck disable=SC2004
mkdir -p "${TEST_ROOT}"
head -c ${CHAT_BACKUP_SIZE} </dev/urandom >${TEST_ROOT}/${CHAT_BACKUP}
head -c ${DB_BACKUP_SIZE} </dev/urandom >${TEST_ROOT}/${DB_BACKUP}

create_info \
  ${TEST_ROOT} \
  ${INFO_FILE} \
  ${CHAT_BACKUP} \
  ${DB_BACKUP}

if ! [ -f "${TEST_ROOT}/${INFO_FILE}" ]
 then
   echo "Test failed. ${TEST_ROOT}/${INFO_FILE} hasn't been created"
   cleanUp
   exit 1
fi

CONTENT=$(<"${TEST_ROOT}/${INFO_FILE}")
# Declare an DIR_ARR
declare -a LINE_ARRAY

# Use a while-read loop to read each line of the CONTENT into an DIR_ARR
while IFS= read -r LINE
do
  # Append the line to the DIR_ARR
  LINE_ARRAY+=("$LINE")
done <<< "$CONTENT"


# Perform the test
if [[ ${LINE_ARRAY[0]} = "# Mattermost backup session" ]] &&
   [[ ${LINE_ARRAY[1]} == BACKUP_DATE* ]] &&
   [[ ${LINE_ARRAY[2]} == "MM_BACKUP_SIZE=52K" ]] &&
   [[ ${LINE_ARRAY[3]} == "DB_BACKUP_SIZE=32K" ]]
then
  echo 'Test successful'
else
  echo 'Test failed'
fi
cleanUp
