Azure Blob CLI Uploader

Overview

azure_blob_uploader.sh is a simple command-line tool designed to allow users to upload files to an Azure Blob container directly from their terminal. This tool provides a seamless, interactive upload experience by prompting users for the file path and destination blob name.

Prerequisites

Before using the tool, ensure you have the following prerequisites:

Azure CLI: You must have Azure CLI installed and configured on your machine.
Installation guide: Install Azure CLI
Azure Storage Account: You need an Azure Storage account with at least one Blob container.
If you don’t have one, follow this guide: Create a storage account
Access to the Blob container: Ensure that you have the appropriate access key for your Azure Storage account.
You can find it in the Azure portal under your storage account's "Access keys."
Setup

1. Clone the Repository
Download or clone this repository to your local machine:

bash
Copy code
git clone https://github.com/yourusername/azure_blob_uploader.git
Navigate into the repository directory:

bash
Copy code
cd azure_blob_uploader
2. Make the Script Executable
Ensure the azure_blob_uploader.sh script is executable:

bash
Copy code
chmod +x azure_blob_uploader.sh
3. Configure the Script
Open the script in your favorite text editor and set the following values:

CONTAINER_NAME: Replace with the name of your Azure Blob container.
STORAGE_ACCOUNT: Replace with your Azure storage account name.
STORAGE_ACCOUNT_KEY: Replace with your storage account access key.
For example:

bash
Copy code
CONTAINER_NAME="my-container"
STORAGE_ACCOUNT="mystorageaccount"
STORAGE_ACCOUNT_KEY="myaccesskey1234567890"
4. Add to Your $PATH
To make the tool accessible from any directory, you can add it to your $PATH.

Move the script to a location like /usr/local/bin:

bash
Copy code
sudo mv azure_blob_uploader.sh /usr/local/bin/azure_blob_uploader
Now, you can call the uploader from any directory using azure_blob_uploader.

5. Install Script (Optional)
You can automate the above steps with a simple installation script. Here's an example install.sh script:

bash
Copy code
#!/bin/bash

# Move the script to /usr/local/bin for global access
sudo cp azure_blob_uploader.sh /usr/local/bin/azure_blob_uploader
sudo chmod +x /usr/local/bin/azure_blob_uploader

echo "Installation complete! You can now use 'azure_blob_uploader' from any directory."
Make this script executable:

bash
Copy code
chmod +x install.sh
Run it to install the uploader tool:

bash
Copy code
./install.sh
Usage

Once set up, you can upload files by running the script as follows:

bash
Copy code
azure_blob_uploader
You will be prompted for the source file path and the destination blob name.

Example:
bash
Copy code
$ azure_blob_uploader
Source (file path): /path/to/local/file.txt
Destination (blob file name): myfileinblob.txt
The tool will upload the file to the Azure Blob container and display a success message upon completion.

Example Output:
sql
Copy code
Source (file path): /path/to/file.txt
Destination (blob file name): file-in-blob.txt
Uploading '/path/to/file.txt' to Azure Blob container...
Greetings, the file has been successfully uploaded to Azure Blob container!
Details for 'file-in-blob.txt' in Azure Blob container:
{
  ...
}
Common Issues and Troubleshooting

1. Azure CLI not installed
If the script fails with an error like az: command not found, it means Azure CLI is not installed or not configured properly.

Solution: Install Azure CLI by following the Azure CLI installation guide.

2. Invalid storage account key or name
If the upload fails with an authentication error, ensure that the STORAGE_ACCOUNT and STORAGE_ACCOUNT_KEY variables are correctly set in the script.

Solution: Double-check your Azure portal for the correct access key and storage account name. Ensure they match what's configured in the script.

3. File not found
If you encounter an error like ERROR: File '/path/to/file' does not exist, ensure that the file path you provide is valid.

Solution: Make sure that the file exists at the specified path and that you have read permissions for the file.

4. Permission denied error
If you run into a Permission denied error when installing the script to /usr/local/bin or while executing, you may not have sufficient privileges.

Solution: Use sudo for commands that require elevated permissions, such as moving the script to /usr/local/bin or modifying executable permissions.

5. Azure CLI authentication issues
If you're encountering errors related to Azure CLI login, make sure you're signed in:

bash
Copy code
az login
You may need to authenticate with your Azure credentials.


Contributing

Feel free to open issues or pull requests for improvements or bug fixes!

