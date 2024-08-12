#!/bin/bash

echo "Are you sure you want to uninstall your server? (Yes/No)"
read choice

choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]')

if [[ "$choice" == "yes" ]]; then
    echo "Uninstalling server..."
    sudo rm -rf server
    echo "Server uninstalled."
elif [[ "$choice" == "no" ]]; then
    echo "Be careful next time :3..."
else 
    echo "Invalid choice."
fi
