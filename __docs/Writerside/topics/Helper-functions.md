# Helper functions

The provided code contains two shell functions: `rotate_backups` and `create_info`. Let's break down each function and understand what it does.

1. **rotate_backups:**
   This function rotates backups by moving existing backups to a higher numbered directory and deleting the oldest backup if the maximum backup limit has been reached.

   Here's how the function works:
    - It takes four parameters: `BACKUP_PATH`, `CURRENT_BACKUP_DIR`, `BASE_BACKUP_DIR_NAME`, and `MAX_BACKUPS`.
    - It checks if the `BACKUP_PATH` directory exists. If not, it prints an error message and returns `1`.
    - It changes the current directory to the `BACKUP_PATH` using `cd "$BACKUP_PATH"` (assuming the directory exists).
    - It checks if the maximum number of backups (`MAX_BACKUPS`) has been reached. If so, it deletes the oldest backup (`"$BASE_BACKUP_DIR_NAME$MAX_BACKUPS"`) using `rm -rf`.
    - It then iterates from `(MAX_BACKUPS-1)` to `1` in reverse order. For each iteration, it checks if the backup directory exists (`"$BASE_BACKUP_DIR_NAME$i"`). If it does, it renames it to the next number (`"$BASE_BACKUP_DIR_NAME$((i+1))"`) using `mv`.
    - Finally, it renames the previous current backup directory (`"$CURRENT_BACKUP_DIR"`) to `"$BASE_BACKUP_DIR_NAME"1` using `mv`.

2. **create_info:**
   This function creates an info file with metadata about a Mattermost backup session.

   Here's how the function works:
    - It takes four parameters: `BACKUP_PATH`, `INFO_FILE`, `CHAT_BACKUP`, and `DB_BACKUP`.
    - It calculates the sizes of the `CHAT_BACKUP` and `DB_BACKUP` directories using `du -sh` and `awk`.
    - It creates an empty info file at `"$BACKUP_PATH/$INFO_FILE"` using `touch`.
    - It appends data to the info file using curly-brace grouping and redirection (`{ } >> "$BACKUP_PATH/$INFO_FILE"`). The data includes:
        - A comment line indicating it's a Mattermost backup session.
        - Backup date and time (`BACKUP_DATE`) using the `date` command.
        - Mattermost backup size (`MM_BACKUP_SIZE`).
        - Database backup size (`DB_BACKUP_SIZE`).

These functions provide functionality for rotating backups and creating an info file with metadata for a Mattermost backup session.