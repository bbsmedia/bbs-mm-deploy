#!/bin/bash

TEST_ROOT="/tmp"
BACKUP_DIR="backup_dir"
CURRENT_BACKUP_DIR="current"
BASE_BACKUP_DIR_NAME="backup"
MAX_BACKUPS=$((5))

source bacup.fn.sh

function cleanUp() {
  # shellcheck disable=SC2115
  rm -rf "${TEST_ROOT}/${BACKUP_DIR}"
}

if [ -f "$TEST_ROOT/$BACKUP_DIR" ]
then
  # cleanup old test data files and dirs
  # shellcheck disable=SC2115
  rm -rf "${TEST_ROOT}/${BACKUP_DIR}"
fi

# re-crate the test working directory
# shellcheck disable=SC2004
mkdir -p "${TEST_ROOT}/${BACKUP_DIR}"

# create the dummy backup directories
for ((i=1; i<=MAX_BACKUPS; i++))
do
  # create the dummy backup directories
  mkdir "${TEST_ROOT}/${BACKUP_DIR}/backup${i}"
  # and dummy content files
  touch "${TEST_ROOT}/${BACKUP_DIR}/backup${i}/dummy${i}"
done
# create the dummy "current" backup dir
mkdir "${TEST_ROOT}/${BACKUP_DIR}/${CURRENT_BACKUP_DIR}"
# and the dummy current content file
touch "${TEST_ROOT}/${BACKUP_DIR}/${CURRENT_BACKUP_DIR}/dummy_current"


# call the tested function with
# its corresponding parameters
rotate_backups \
  "${TEST_ROOT}/${BACKUP_DIR}" \
  "$CURRENT_BACKUP_DIR" \
  "$BASE_BACKUP_DIR_NAME" \
  "$MAX_BACKUPS"
# start testing the result of the tested function execution

#test if the former CURRENT_BACKUP_DIR has been renamed
if [ -d "${TEST_ROOT}/${BACKUP_DIR}/${CURRENT_BACKUP_DIR}" ]
  then
    echo "Test failed. $CURRENT_BACKUP_DIR should have been renamed to ${BASE_BACKUP_DIR_NAME}1"
    cleanUp
    exit 1
fi

# first check for the existence of the MAX_BACKUPS directory
if ! [ -d "${TEST_ROOT}/${BACKUP_DIR}/${BASE_BACKUP_DIR_NAME}${MAX_BACKUPS}" ]
  then
    echo "Test failed. Missing \"backup5\" directory"
    cleanUp
    exit 1
fi

# test if the contents of the previous dir is right one
# (should be the number at the end of the name of the directory - 1)
if ! [ -f "${TEST_ROOT}/${BACKUP_DIR}/${BASE_BACKUP_DIR_NAME}${MAX_BACKUPS}/dummy$((MAX_BACKUPS - 1))" ]
  then
    echo "Test failed. Missing \"dummy4\" file inside the $BASE_BACKUP_DIR_NAME$MAX_BACKUPS directory"
    cleanUp
    exit 1
fi

# check if
if ! [ -f "${TEST_ROOT}/${BACKUP_DIR}/${BASE_BACKUP_DIR_NAME}1/dummy_current" ]
  then
    echo "Test failed. Missing \"dummy4\" file inside the $BASE_BACKUP_DIR_NAME$MAX_BACKUPS directory"
    cleanUp
    exit 1
fi

echo "Test successful"
cleanUp
