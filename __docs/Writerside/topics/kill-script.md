# kill script

This is a bash script that performs some operations based on user input. Here is a breakdown of the script:

1. `#!/bin/bash`: This line specifies that the script should be run using the Bash shell.

2. `source vars.sh`: This line sources the content of the `vars.sh` file into the current script. This means that any variables or functions defined in `vars.sh` will be available in this script.

3. `read -p "Are you sure? " -n 1 -r`: This line prompts the user with the question "Are you sure?" and waits for the user to input a single character. The `-p` option specifies the prompt text, the `-n 1` option limits the input to a single character, and the `-r` option prevents the backslash from being treated as an escape character.

4. `echo`: This line is optional and simply moves the cursor to a new line before displaying any output to the console.

5. `if [[ $REPLY =~ ^[Yy]$ ]]; then`: This line starts an `if` statement that checks if the user's input stored in the `REPLY` variable matches the regular expression `^[Yy]$`, which represents a single character that is either "Y" or "y". If the condition is true, the code within the `if` block is executed.

6. Inside the `if` block, the following commands are executed:
    - `echo "deleting $VOLUMES_MM_PATH"`: This line echoes a message indicating that the variable `$VOLUMES_MM_PATH` is being deleted.
    - `docker rm -f "${MM_CONTAINER_NAME}"`: This line stops and removes a Docker container specified by the variable `$MM_CONTAINER_NAME`.
    - `echo "deleting $PG_DATA_PATH"`: This line echoes a message indicating that the variable `$PG_DATA_PATH` is being deleted.
    - `docker rm -f "${PG_CONTAINER_NAME}"`: This line stops and removes a Docker container specified by the variable `$PG_CONTAINER_NAME`.
    - `echo "deleting $VOLUMES_MM_PATH"`: This line echoes a message indicating that the variable `$VOLUMES_MM_PATH` is being deleted.
    - `rm -rf "$VOLUMES_MM_PATH"`: This line removes the directory specified by the variable `$VOLUMES_MM_PATH` and all its contents recursively.
    - `echo "deleting $PG_DATA_PATH"`: This line echoes a message indicating that the variable `$PG_DATA_PATH` is being deleted.
    - `rm -rf "$PG_DATA_PATH"`: This line removes the directory specified by the variable `$PG_DATA_PATH` and all its contents recursively.
    - `echo "Creating directories..."`: This line echoes a message indicating that directories are being created.
    - `mkdir "${MM_DIR_LIST[@]}"`: This line creates directories specified by the DIR_ARR variable `$MM_DIR_LIST`.
    - `echo "Changing owners..."`: This line echoes a message indicating that ownership is being changed.
    - `chown -R 2000:2000 "$VOLUMES_MM_PATH"`: This line changes the ownership of the directory specified by the variable `$VOLUMES_MM_PATH` and all its contents to the user and group with the IDs 2000.
    - `chown -R 2000:2000 "$PG_DATA_PATH"`: This line changes the ownership of the directory specified by the variable `$PG_DATA_PATH` and all its contents to the user and group with the IDs 2000.

7. The `fi` keyword marks the end of the `if` block.

Overall, this script asks the user for confirmation, and if the user responds with "Y" or "y", it deletes specified Docker containers and directories, creates new directories, and changes the ownership of certain directories.