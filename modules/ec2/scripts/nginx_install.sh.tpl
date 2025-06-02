#!/bin/bash

sudo yum update -y
sudo yum install nginx -y
sudo systemctl enable --now nginx

cat <<EOF | sudo tee /etc/nginx/conf.d/reverse-proxy.conf
server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://${private_alb_dns_name};
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo systemctl restart nginx