#!/bin/bash

# Update system packages
apt update
apt upgrade -y

# Install Nginx
apt install nginx -y

# Install Certbot
apt install certbot python3-certbot-nginx -y

# Configure Nginx to serve your domain
cat <<EOF > /etc/nginx/sites-available/your_domain
server {
    listen 80;
    server_name your_domain;

    location / {
        proxy_pass https://localhost:YOUR_PORT;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

# Enable the site
ln -s /etc/nginx/sites-available/your_domain /etc/nginx/sites-enabled/

# Test Nginx configuration and reload
nginx -t
systemctl reload nginx

# Obtain SSL certificate
certbot --nginx -d your_domain --non-interactive --agree-tos -m admin@your_domain

# Automate certificate renewal
(crontab -l 2>/dev/null; echo "0 0 * * * /usr/bin/certbot renew --quiet") | crontab -

# Secure Nginx configuration
#chmod 600 /etc/letsencrypt/live/your_domain/fullchain.pem
#chmod 600 /etc/letsencrypt/live/your_domain/privkey.pem

# Reload Nginx
systemctl reload nginx

echo "SSL setup for Nginx on Ubuntu is complete."
