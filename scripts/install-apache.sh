#!/bin/bash

# Update packages
sudo yum update -y

# Install Apache
sudo yum install -y httpd

# Start Apache service
sudo systemctl start httpd
sudo systemctl enable httpd

# Create a simple HTML page with instance info
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

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
    <h1>Hello World from DevOps Assessment!</h1>
    <div class="info">
        <h2>Instance Information</h2>
        <p><strong>Instance ID:</strong> $INSTANCE_ID</p>
        <p><strong>Public IP:</strong> $PUBLIC_IP</p>
        <p><strong>Region:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone | sed 's/.$//')</p>
    </div>
</body>
</html>
EOF
