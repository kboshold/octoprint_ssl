# HTTPS for OctoPi / OctoPrint

This is just a bundle of scripts to setup HTTPS for OctoPi / OctoPrint. The scripts does use `LetsEncrypt` for creating the SSL certificates. Make sure you have an DNS provider supporting the LetsEncrypt DNS challange ([DNS providers who easily integrate with Let’s Encrypt DNS validation](https://community.letsencrypt.org/t/dns-providers-who-easily-integrate-with-lets-encrypt-dns-validation/86438) )

## Setup

```bash
curl https://raw.githubusercontent.com/kpalatzky/octoprint_ssl/master/scripts/install.sh | sh
```

## Configuration

```bash
# General settings
OCTOPRINT_SSL_PROVIDER=certbot-cloudflare-dns               # Possible values: certbot-cloudflare-dns , local
OCTOPRINT_SSL_DOMAIN=octoprint.local                        # Your domain
OCTOPRINT_SSL_DISABLE_HTTP=true                             # True to disable http

# [LOCAL][Optional] May adjust these settings when OCTOPRINT_SSL_PROVIDER=local
OCTOPRINT_SSL_LOCAL_PASSWORD=octoprint                      # Password for protecting "private keys"
OCTOPRINT_SSL_LOCAL_COUNTRY=DE                              # Your country
OCTOPRINT_SSL_LOCAL_STATE=Baveria                           # Your state
OCTOPRINT_SSL_LOCAL_LOCALITY=Munich                         # Your city
OCTOPRINT_SSL_LOCAL_ORGANIZATION=OctoPrint-SSL              # Your organization name
OCTOPRINT_SSL_LOCAL_NAME=$OCTOPRINT_SSL_DOMAIN              # Your local name

# [CLOUDFLARE]
OCTOPRINT_SSL_CERTBOT_EMAIL=user@mydomain.com               # E-Mail to get notified in urgent cases
OCTOPRINT_SSL_CERTBOT_CLOUDFLARE_API_TOKEN=YourToken        # Your cloudflare token. The tokens requires `Zone:DNS:Edit`. Create your token here: https://dash.cloudflare.com/profile/api-tokens
OCTOPRINT_SSL_CERTBOT_CLOUDFLARE_API_AUTORENEW=true         # true to enable autorenew
```