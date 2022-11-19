mkdir -p /opt/ssl

if ! command -v sed &> /dev/null
then
    apt-get install -y sed
fi

# install required software
if [ "$OCTOPRINT_SSL_PROVIDER" = "certbot" ]; then
    apt-get install -y software-properties-common python-certbot-nginx python-pip
    pip install certbot-dns-cloudflare
fi

# generate certificate
./generate.sh

# set haproxy stuff
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak
sed -i "s|bind :::443 .*|bind :::443 v4v6 ssl crt /opt/ssl/$OCTOPRINT_SSL_DOMAIN.pem ca-file /opt/ssl/OctoPrintCA.crt verify required|" /etc/haproxy/haproxy.cfg

service haproxy restart