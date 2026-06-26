#!/bin/bash

## abandoning sites-enabled and applying a descriptive name to the server block
sudo cp /etc/nginx/sites-enabled/default /etc/nginx/conf.d/files.conf

sudo cp /home/student/git/devops-the-alta3-way/labs/base-nginx.conf /etc/nginx/nginx.conf

sudo nginx -t

sudo systemctl restart nginx.service
echo $?
echo "Completed Setup"
