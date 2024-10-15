#!/bin/bash

# A function to upload a file to a predetermined Azure Blob container
azure_blob_upload() {
    # Read the source file path from the user
    echo -n "Source (file path): "
    read source

    # Read the destination (blob container file name) from the user
    echo -n "Destination (blob file name): "
    read destination

    # Check if the source file exists
    if [ ! -f "$source" ]; then
        echo "ERROR: File '$source' does not exist. Exiting..."
        exit 1
    fi

    # Define Azure storage details (you should replace these with actual values)
    CONTAINER_NAME="<PLACECONTAINERNAMEHERE>"
    STORAGE_ACCOUNT="<PLACESTRGNAMEHERE>"
    STORAGE_ACCOUNT_KEY="<PLACEKEYHERE>"

    # Upload the file to Azure Blob Storage using Azure CLI
    az storage blob upload \
        --container-name "$CONTAINER_NAME" \
        --file "$source" \
        --name "$destination" \
        --account-name "$STORAGE_ACCOUNT" \
        --account-key "$STORAGE_ACCOUNT_KEY"

    # Check the result of the upload
    if [ $? = 0 ]; then
        echo "Greetings, the file has been successfully uploaded to Azure Blob container!"
    else
        echo "ERROR: File failed to be uploaded. Exiting... Till next time…Take care!"
        exit 1
    fi

    # Show details of the uploaded file
    echo "Details for '$destination' in Azure Blob container:"
    az storage blob show \
        --container-name "$CONTAINER_NAME" \
        --name "$destination" \
        --account-name "$STORAGE_ACCOUNT" \
        --account-key "$STORAGE_ACCOUNT_KEY"
    
    return $?
}

# Call the upload function
azure_blob_upload

# Output the function's return value
echo "The function has a return value of $?"