# Mattermost Deployment Docs


MATTERMOST OPERATIONS:

[[ TODO ]] : Incremental backup

Specifically for this installation the user $USR is: webadmin

BASE_DIR is /home/$USR
BACKUP_DIR is $BASE_DIR/chat_backup
The rest of the variables are defined in the
"vars.sh" file in the $BASE_DIR

Docker specific files in:
$BASE_DIR/docker/mattermost

### Scripts:
~~1.  **kill.mm**
    - kills all containers
    - removes all data dirs from both Mattermost and postgres containers
    - recreates all dirs 
    - sets the appropriate permissions to each of them
1. **init.mm**
    - starts the docker containers
2. **backup.mm**
    - stops the mattermost container
    - creates the Mattermost files archive
    - dumps database data
    - writes backup data in the $BACKUP_DIR
3. **restore.mm**
    - cleans up all Mattermost existing data files
    - extracts the archive in its place
    - restores the database data from the backup dump file
    - restarts the Mattermost container~~
