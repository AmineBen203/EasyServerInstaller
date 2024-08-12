#!/bin/bash

sudo apt update -qq
sudo apt install -y -qq jq curl

cd ..
mkdir -p server 
cd server

LATEST_VERSION=`sudo curl -s https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.release'`
LATEST_SNAPSHOT_VERSION=`sudo -s curl https://launchermeta.mojang.com/mc/game/version_manifest.json | jq -r '.latest.snapshot'`

echo "Latest minecraft version is ", $LATEST_VERSION
echo "Latest snapshot version is ", $LATEST_SNAPSHOT_VERSION

echo "Enter version: "
VANILLA_VERSION=latest
read $VANILLA_VERSION

if [ -z "$VANILLA_VERSION" ] || [ "$VANILLA_VERSION" == "latest" ]; then
    MANIFEST_URL=$(curl -sSL https://launchermeta.mojang.com/mc/game/version_manifest.json | jq --arg VERSION $LATEST_VERSION -r '.versions | .[] | select(.id== $VERSION )|.url')
elif [ "$VANILLA_VERSION" == "snapshot" ]; then
  MANIFEST_URL=$(curl -sSL https://launchermeta.mojang.com/mc/game/version_manifest.json | jq --arg VERSION $LATEST_SNAPSHOT_VERSION -r '.versions | .[] | select(.id== $VERSION )|.url')
else
  MANIFEST_URL=$(curl -sSL https://launchermeta.mojang.com/mc/game/version_manifest.json | jq --arg VERSION $VANILLA_VERSION -r '.versions | .[] | select(.id== $VERSION )|.url')
fi    

DOWNLOAD_URL=$(curl ${MANIFEST_URL} | jq .downloads.server | jq -r '. | .url')
if [ -z $DOWNLOAD_URL ]
then
  echo "Invalid version provided"
  exit 1
fi

echo -e "running: curl -o server.jar $DOWNLOAD_URL"
sudo curl -o server.jar $DOWNLOAD_URL 

echo "Installation was successfully complete... :D"