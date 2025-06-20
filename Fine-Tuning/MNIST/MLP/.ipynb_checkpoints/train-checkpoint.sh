#!/bin/bash

NOTEBOOK_DIR="./"
LOG_FILE="train.log"
DONE_FILE="completed_notebooks.txt"

# Get list of notebooks
mapfile -t ALL_FILES < <(find "$NOTEBOOK_DIR" -maxdepth 1 -name "*.ipynb" -printf "%f\n" | sort)

# Create done file if it doesn't exist
touch "$DONE_FILE"

# Get list of completed notebooks
mapfile -t DONE_FILES < "$DONE_FILE"

# Check if all notebooks are done
if [ "${#ALL_FILES[@]}" -eq "${#DONE_FILES[@]}" ]; then
    echo "$(date '+%Y-%m-%d %H:%M:%S') - All notebooks already completed. Restarting training from scratch." | tee "$LOG_FILE"
    rm -f "$DONE_FILE"
    touch "$DONE_FILE"
fi

# Trap to catch crashes and log them
trap 'echo "$(date "+%Y-%m-%d %H:%M:%S") - Script interrupted or crashed." >> "$LOG_FILE"' EXIT

# Execute each notebook
for filename in "${ALL_FILES[@]}"; do
    # Check if already completed
    if grep -Fxq "$filename" "$DONE_FILE"; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Skipping (already completed): $filename" | tee -a "$LOG_FILE"
        continue
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S') - Starting: $filename" | tee -a "$LOG_FILE"

    # Run notebook and check status
    if jupyter nbconvert --to notebook --execute "$NOTEBOOK_DIR/$filename" --output "$NOTEBOOK_DIR/$filename" >> "$LOG_FILE" 2>&1; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Finished: $filename ✅" | tee -a "$LOG_FILE"
        echo "$filename" >> "$DONE_FILE"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Error during: $filename ❌" | tee -a "$LOG_FILE"
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Aborting. You can rerun the script to resume from here." | tee -a "$LOG_FILE"
        exit 1
    fi
done

echo "$(date '+%Y-%m-%d %H:%M:%S') - All notebooks executed successfully." | tee -a "$LOG_FILE"