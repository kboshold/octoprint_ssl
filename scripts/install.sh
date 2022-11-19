if ! command -v git &> /dev/null
then
    apt-get install -y git 
fi

/usr/bin/git clone --depth 1 https://github.com/kpalatzky/octoprint_ssl /opt/octoprint_ssl