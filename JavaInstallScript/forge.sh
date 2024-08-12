#!/bin/bash

# Install dependencies
sudo apt update -qq
sudo apt install -y -qq jq curl

cd ..
mkdir -p server
cd server

# Define main directory and fetch Forge versions data
export MAIN_DIR=$(pwd)
echo -e '-> Fetching Forge versions data...'
JSON_DATA=$(curl -sSL https://files.minecraftforge.net/maven/net/minecraftforge/forge/promotions_slim.json)
FILE_SITE=https://maven.minecraftforge.net/net/minecraftforge/forge/


# Prompt user for Minecraft version
echo -e "\nEnter Minecraft version (e.g., 1.19.2): "
MC_VERSION=latest
read MC_VERSION

# Validate user input
if [ -z "$MC_VERSION" ]; then
    echo -e "Minecraft version cannot be empty."
    exit 1
fi

# Find the appropriate Forge version
VERSION_KEY=$(echo -e ${JSON_DATA} | jq -r --arg MC_VERSION "${MC_VERSION}" '.promos | to_entries[] | select(.key | contains($MC_VERSION)) | .key' | head -1)

if [ -z "$VERSION_KEY" ]; then
    echo -e "No Forge version found for Minecraft version ${MC_VERSION}."
    exit 1
fi

FORGE_VERSION=$(echo -e ${JSON_DATA} | jq -r --arg VERSION_KEY "$VERSION_KEY" '.promos | .[$VERSION_KEY]')

# Construct the download URL
DOWNLOAD_LINK=${FILE_SITE}${MC_VERSION}-${FORGE_VERSION}/forge-${MC_VERSION}-${FORGE_VERSION}
INSTALLER_URL=${DOWNLOAD_LINK}-installer.jar

# Check if the download link is valid
echo -e "Checking download link: ${INSTALLER_URL}"
if curl --output /dev/null --silent --head --fail ${INSTALLER_URL}; then
    echo -e "Download link is valid. Proceeding with download."
else
    echo -e "Download link is invalid. Exiting."
    exit 2
fi

# Download Forge installer
curl -s -o installer.jar ${INSTALLER_URL}

# Check if the installer was downloaded successfully
if [ ! -f ./installer.jar ]; then
    echo -e "Error downloading Forge installer for version ${FORGE_VERSION}."
    exit 3
fi

# Install Forge server
echo -e "Installing Forge server."
java -jar installer.jar --installServer || { echo -e "Install failed"; exit 4; }

echo -e "Renaming server JAR file..."
for jar_file in minecraft_server*.jar; do
    if [ -f "$jar_file" ]; then
        echo "Renaming $jar_file to server.jar"
        mv "$jar_file" server.jar
    else
        echo "No server JAR file found to rename."
    fi
done

# Clean up
echo -e "Deleting installer.jar file."
rm -rf installer.jar

echo -e "Forge server setup complete."
