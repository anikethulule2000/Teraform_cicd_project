#!/bin/bash

# Update packages
sudo yum update -y

# Install Apache
sudo yum install -y httpd

# Start Apache service
sudo systemctl start httpd
sudo systemctl enable httpd

sudo echo "<h1> Hello World new </h1>" > /var/www/html/index.html
