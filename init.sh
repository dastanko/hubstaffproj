#!/bin/bash -xe
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker
docker run -d --restart=always -p 3000:3000 ghcr.io/benc-uk/nodejs-demoapp:latest

