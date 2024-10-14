#!/bin/bash

# Function to display usage help
function usage() {
    echo "Usage: clouduploader /path/to/file.txt"
    echo "Example: clouduploader /path/to/file.txt"
    exit 1
}

# Check if the file path is provided
if [ -z "$1" ]; then
    echo "Error: No file path provided."
    usage
fi

# Define the file path
FILE_PATH="$1"

# Validate if the file exists
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' not found!"
    exit 1
fi

# Display input information
echo "File to upload: $FILE_PATH"

# Main function
function upload_file() {
    echo "Uploading '$FILE_PATH' to Azure Storage..."

    # Example Azure CLI command to upload file to blob storage
    az storage blob upload \
        --container-name "default-container" \   # Using a fixed container
        --file "$FILE_PATH" \
        --name "$(basename "$FILE_PATH")"

    # Check if the command succeeded
    if [ $? -eq 0 ]; then
        echo "Success: File '$FILE_PATH' uploaded successfully!"
    else
        echo "Error: Failed to upload '$FILE_PATH'. Please check the file path, permissions, or cloud configuration."
        exit 1
    fi
}

# Execute the upload function
upload_file
