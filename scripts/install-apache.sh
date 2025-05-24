#!/bin/bash

# Update packages
sudo yum update -y

# Install Apache
sudo yum install -y httpd

# Start Apache service
sudo systemctl start httpd
sudo systemctl enable httpd

sudo bash -c "cat > /var/www/html/index.html" <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>DevOps Assessment</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        h1 { color: #2c3e50; }
        .info { background-color: #f8f9fa; padding: 20px; border-radius: 5px; 
                display: inline-block; margin: 10px; }
    </style>
</head>
<body>
    <h1>Hello World </h1>
</body>
</html>
EOF
