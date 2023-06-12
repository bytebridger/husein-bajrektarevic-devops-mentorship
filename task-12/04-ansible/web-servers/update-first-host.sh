#!/bin/bash

sudo bash -c 'cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
    <head>
        <title>Web Server</title>
    </head>
    <body>
        <h1>Hello from nginx web server created using CloudFormation and Ansible</h1>
    </body>
</html>
EOF'
