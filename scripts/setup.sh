mkdir -p /opt/ssl

# install required software
if [ "$OCTOPRINT_SSL_PROVIDER" = "certbot" ]; then
    if ! command -v certbot &> /dev/null
    then
        apt-get install -y certbot
    fi
fi

# generate certificate
./generate.sh

# set haproxy stuff
cd /etc/haproxy
cp haproxy.cfg haproxy.cfg.bak
nano haproxy.cfg


