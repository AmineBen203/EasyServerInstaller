install_server() {
    choice=$1

    if [[ $choice == 1 ]]; then
        echo -e ">>>Installing vanilla..."
        cd JavaInstallScript
        chmod +x *
        ./vanilla.sh
    else
        echo "Inavalid choice"
    fi
}

echo "[1] For vanilla server"
choiceServer=1
read choiceServer
install_server $choiceServer

echo ">>>Installing PlayIt..."
cd ..
cd server 
wget -q "https://github.com/playit-cloud/playit-agent/releases/download/v0.15.18/playit-linux-amd64" -o playit
chmod +x *

echo ">>>PlayIt was completely installed"
echo "Your server is ready"
echo "[1] to start server now"
echo "[2] for later"


startServer=1
read startServer

if [ $startServer == "1" ]; then
    # Prompt user for agreement to the EULA
    echo "Do you agree to the Minecraft EULA? (yes/no)"
    read userResponse

    if [[ $userResponse == "yes" ]]; then
        # Check if eula.txt exists
        if [ -f eula.txt ]; then
            # Update eula.txt to set eula=true
            sed -i 's/eula=false/eula=true/' eula.txt
        else
            # Create eula.txt and set eula=true
            echo "eula=true" > eula.txt
        fi
        echo "EULA accepted. Starting the server..."
        java -jar server.jar
    else
        echo "You must agree to the EULA to start the server."
        exit 1
    fi
elif [ $startServer == "2" ]; then
    echo "You can open server by using this prompt: "
    echo "java -jar server.jar"
fi