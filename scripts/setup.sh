mkdir -p /opt/ssl

if ! command -v sed &> /dev/null
then
    apt-get install -y sed
fi

# install required software
if [ "$OCTOPRINT_SSL_PROVIDER" = "certbot-cloudflare-dns" ]; then
    apt-get install -y software-properties-common python-certbot-nginx python-pip
    pip3 install certbot-dns-cloudflare

    mkdir /root/.secrets
    chmod 0700 /root/.secrets/
    touch /root/.secrets/cloudflare.cfg
    chmod 0400 /root/.secrets/cloudflare.cfg
fi

# generate certificate
./generate.sh

# set haproxy stuff
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.bak

if [ "$OCTOPRINT_SSL_PROVIDER" = "local" ]; then
    sed -i "s|bind :::443 .*|bind :::443 v4v6 ssl crt /opt/ssl/$OCTOPRINT_SSL_DOMAIN.pem ca-file /opt/ssl/OctoPrintCA.crt verify required|" /etc/haproxy/haproxy.cfg
fi

if [ "$OCTOPRINT_SSL_PROVIDER" = "certbot-cloudflare-dns" ]; then
    sed -i "s|bind :::443 .*|bind :::443 v4v6 ssl crt  /etc/letsencrypt/live/$OCTOPRINT_SSL_DOMAIN/$OCTOPRINT_SSL_DOMAIN.pem|" /etc/haproxy/haproxy.cfg
fi

if [ "$OCTOPRINT_SSL_DISABLE_HTTP" = "true" ]; then
    sed -i -E "s|(#\s*)?(bind :::80 .*)|# \2|" /etc/haproxy/haproxy.cfg
else 
    sed -i -E "s|(#\s*)?(bind :::80 .*)|\2|" /etc/haproxy/haproxy.cfg
fi

if [ "$OCTOPRINT_SSL_CERTBOT_CLOUDFLARE_API_AUTORENEW" = "true" ]; then
    crontab -l > .cronjobs
    cat >> .cronjobs <<EOF
14 5 * * * python3 /usr/local/bin/certbot renew --quiet --post-hook "service haproxy restart" > /dev/null 2>&1
EOF
    crontab .cronjobs
    rm .cronjobs
fi 
service haproxy restart

