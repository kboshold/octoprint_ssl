if [ "$OCTOPRINT_SSL_PROVIDER" = "certbot" ]; then
    python3 /usr/local/bin/certbot certonly 
fi

if [ "$OCTOPRINT_SSL_PROVIDER" = "local" ]; then
    LOCAL_SUBJECT="/C=$OCTOPRINT_SSL_LOCAL_COUNTRY/ST=$OCTOPRINT_SSL_LOCAL_STATE/L=$OCTOPRINT_SSL_LOCAL_LOCALITY/O=$OCTOPRINT_SSL_LOCAL_ORGANIZATION/CN=$OCTOPRINT_SSL_LOCAL_NAME"
    openssl genrsa -passout "pass:$OCTOPRINT_SSL_PASSWORD" -des3 -out /opt/ssl/OctoPrintCA.key 4096
    openssl req -passin "pass:$OCTOPRINT_SSL_PASSWORD" -subj $LOCAL_SUBJECT -x509 -new -nodes -key /opt/ssl/OctoPrintCA.key -sha256 -days 1825 -out /opt/ssl/OctoPrintCA.crt

    openssl genrsa -out "/opt/ssl/$OCTOPRINT_SSL_DOMAIN.key" 2048
    openssl req -passin "pass:$OCTOPRINT_SSL_PASSWORD" -subj $LOCAL_SUBJECT -new -key "/opt/ssl/$OCTOPRINT_SSL_DOMAIN.key" -out "/opt/ssl/$OCTOPRINT_SSL_DOMAIN.csr"
    openssl x509  -passin "pass:$OCTOPRINT_SSL_PASSWORD" -req -in "/opt/ssl/$OCTOPRINT_SSL_DOMAIN.csr" -CA /opt/ssl/OctoPrintCA.crt -CAkey /opt/ssl/OctoPrintCA.key -CAcreateserial -out "/opt/ssl/$OCTOPRINT_SSL_DOMAIN.crt" -days 500 -sha256
    cat "/opt/ssl/$OCTOPRINT_SSL_DOMAIN.crt" "/opt/ssl/$OCTOPRINT_SSL_DOMAIN.key" > "/opt/ssl/$OCTOPRINT_SSL_DOMAIN.pem"

    openssl genrsa -out "/opt/ssl/$USER.key" 2048
    openssl req -subj $LOCAL_SUBJECT -new -key "/opt/ssl/$USER.key" -out "/opt/ssl/$USER.csr"
    openssl x509  -passin "pass:$OCTOPRINT_SSL_PASSWORD" -req -in "/opt/ssl/$USER.csr" -CA "/opt/ssl/OctoPrintCA.crt" -CAkey "/opt/ssl/OctoPrintCA.key" -CAcreateserial -out "/opt/ssl/$USER.crt" -days 499 -sha256
    openssl pkcs12  -passout "pass:$OCTOPRINT_SSL_PASSWORD"  -export -in "/opt/ssl/$USER.crt" -inkey "/opt/ssl/$USER.key" -out "/opt/ssl/$USER.p12"
fi

