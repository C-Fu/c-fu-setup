#!/bin/bash
IP=`hostname  -I | cut -f1 -d' '`

#Install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
sudo usermod -aG docker dietpi #just in case

#Install docker-compose
sudo apt install -y libffi-dev libssl-dev python3 python3-pip
sudo apt remove -y python-configparser
echo "Installing Docker Compose. Will take some time..."
sudo pip3 -v install docker-compose | echo "[Docker]         install : DONE!" && echo "[Docker Compose] install : DONE!"

#Install Portainer
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce | \
echo "[Portainer] deployed at $IP:9000"

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

cd ~/organizr && docker-compose up -d
cd ~/nginxproxy && docker-compose up -d
echo "[portainer] deployed at $IP:9000"
echo "[organizr] deployed at $IP:88"
echo "[nginxproxy] deployed at $IP:181. Port-forward port 80 and 443 to $IP:180 and $IP:1443"

echo "ALL DONE!"
docker ps
exit
