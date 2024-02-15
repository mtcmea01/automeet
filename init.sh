#!/bin/bash

#host : t3.velaconference.business

#EDIT BEFORE RUN!
#Announce Variables
myhostname="t3.velaconference.business" #edit this manually and enter your URL
myip=`curl -4 ifconfig.me`
#rm -rf /automeet
cp -r ./ /automeet
cd /automeet
#Starting script
hostnamectl set-hostname $myhostname
apt update
apt -y install nginx wget lua5.2 certbot python3-certbot-nginx git curl
echo "$myip $myhostname" >> /etc/hosts

# Update the package list
apt-get update

# Install Git, Docker, and Docker-compose if they are not already installed
if ! command -v git &> /dev/null; then
    apt-get install -y git
fi

if ! command -v docker &> /dev/null; then
    apt-get install -y docker.io
fi

if ! command -v docker-compose &> /dev/null; then
    apt-get install -y docker-compose
fi

apt install sed -y

rm -rf jitsi-meet

git clone https://github.com/jitsi/jitsi-meet
cp Dockerfile  docker-compose.yml  sample.nginx.conf jitsi-meet/ -v
cd jitsi-meet
sed -i 's/127.0.0.1/0.0.0.0/g' webpack.config.js
sed -i "s/h1.velaconference.business/$myhostname/g" Dockerfile 
#sed -i 's/getDevServerConfig(),/getDevServerConfig(), disableHostCheck: true,/g' webpack.config.js
#sed -i "s/h1.velaconference.business/$myhostname/g" sample.nginx.conf
sed -i "s/hot: true,/hot: true, allowedHosts: \"$myhostname\",/g" webpack.config.js
docker build -t my-app .

# Stop running containers and services from docker-compose, if any
docker-compose down

# Start the services defined in the docker-compose.yml file in detached mode
docker-compose up -d


#SSL Setup
cp ../ssl.sh . -v
sed -i "s/your_domain/$myhostname/g" ssl.sh
sed -i "s/YOUR_PORT/8080/g" ssl.sh
sh ssl.sh
