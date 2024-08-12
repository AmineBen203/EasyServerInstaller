install_server() {
    choice=$1

    if [[ $choice == 1 ]]; then
        echo -e "-> Installing vanilla..."
        cd JavaInstallScript
        chmod +x *
        ./vanilla.sh 
    elif [[ $choice == 2 ]]; then
        echo -e "-> Installing forge..."
        cd JavaInstallScript
        chmod +x *
        ./forge.sh
    else
        echo "Invalid choice"
    fi
}

echo "[1] For Vanilla server"
echo "[2] For Forge server"
read -p "Choose your server type: " choiceServer

install_server $choiceServer

echo "Installing PlayIt..."
cd ..
cd server 
wget -q -O playit "https://github.com/playit-cloud/playit-agent/releases/download/v0.15.18/playit-linux-amd64" 
chmod +x playit

echo "PlayIt was completely installed :D"
echo "Your server is ready"
echo "[1] to start server now"
echo "[2] for later"

read -p "Choose an option: " startServer

# Function to handle EULA acceptance and server start
start_minecraft_server() {
    echo "Do you agree to the Minecraft EULA? (yes/no)"
    read userResponse

    if [[ $userResponse == "yes" ]]; then
        if [ -f eula.txt ]; then
            sed -i 's/eula=false/eula=true/' eula.txt
        else
            echo "eula=true" > eula.txt
        fi
        echo "EULA accepted."
        
        if [[ $1 == "now" ]]; then
            echo "Starting the server..."
            java -jar server.jar
        else
            echo "You can run ./startServer.sh to start the server anytime!"
        fi
    else
        echo "You must agree to the EULA to start the server."
        exit 1
    fi
}

if [[ $startServer == "1" ]]; then
    start_minecraft_server "now"
elif [[ $startServer == "2" ]]; then
    # Create a start script for later use
    echo -e "#!/bin/bash\njava -jar server.jar" > startServer.sh
    chmod +x startServer.sh
    start_minecraft_server "later"
else
    echo "Invalid option."
    exit 1
fi
