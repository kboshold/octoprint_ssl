if ! command -v git &> /dev/null
then
    apt-get install -y git 
fi

git clone https://github.com/kpalatzky/octoprint_ssl /opt/octoprint_ssl