#!/bin/bash

# Function to check if file exists
check_file_exists() {
    if [ ! -f "$1" ]; then
        echo "File $1 not found."
        exit 1
    fi
}

# Function to trigger Azure Function App for file upload
trigger_function_app() {
    local file="$1"
    local function_app_url="your-function-app-url"

    # Trigger Azure Function App using curl
    response=$(curl -s -X POST -F "file=@$file" "$function_app_url")

    # Check response for success or error
    if [ "$response" == "Success" ]; then
        echo "File uploaded successfully."
    else
        echo "Error: $response"
        exit 1
    fi
}

# Main function
main() {
    # Azure Function App URL
    function_app_url="your-function-app-url"

    # Check if file exists
    check_file_exists "$1"

    # Trigger Azure Function App for file upload
    trigger_function_app "$1" "$function_app_url"
}

# Call main function with filename argument
main "$@"
