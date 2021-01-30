#!/bin/bash

#Install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
echo "Docker install : DONE!"

#Install Portainer
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce

echo "Portainer install : DONE!"

#Pulll all images
sudo docker pull organizr/organizr:latest | echo "[Organizr] pulled"
sudo docker pull jc21/nginx-proxy-manager:latest | echo "[Nginx Proxy Manager] pulled"

echo "Ready to start!"
echo "Creating directories"
mkdir ~/organizr | echo "[organizr] folder created"
mkdir ~/nginxproxy | echo "[nginxproxy] folder created"

echo "Deploying Docker containers..."
cp organizr-docker-compose.yml ~/organizr/docker-compose.yml
cp nginx-proxy-docker-compose.yml ~/nginxproxy/docker-compose.yml

cd ~/organizr && docker-compose up -d   | echo "[organizr] deployed at IP:88"
cd ~/nginxproxy && docker-compose up -d | echo "nginxproxy] deployed at IP:181. Port-forward port 80 and 443 to IP:180 and IP:1443"

echo "ALL DONE!"
docker ps
pause
