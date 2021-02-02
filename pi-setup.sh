#!/bin/bash
IP=`hostname  -I | cut -f1 -d' '`

TITLE="\n\n\e[33m[-------------------------------------]\n[-----------Pi Setup Script-----------]\n[-----------------C-Fu----------------]\n\n"
echo -e $TITLE

#Install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
sudo usermod -aG docker dietpi #just in case

#Install docker-compose
sudo apt install -y libffi-dev libssl-dev 
sudo apt install -y python3 python3-pip
sudo apt remove -y python-configparser
echo -e "\e[33mInstalling Docker Compose. Will take some time..."
sudo pip3 -v install docker-compose 
echo -e "\n\n"
echo -e "\e[33m[Docker]         install : DONE!"
echo -e "\e[33m[Docker Compose] install : DONE!"
echo -e "\n\n"

#Install rclone
echo "Installing rclone..."
curl https://rclone.org/install.sh | sudo bash       && \
echo -e "\n\n"                                       && \
echo -e "\e[33m[RClone]         install : DONE!"     || \
instRClone=1 && echo -e "\n\n\e[31m[RClone]      install : FAILED!"  && \
echo -e "\n\n"

#Install Portainer
docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce && \
echo -e "\n\n"                                                            && \
echo -e "\e[33m[Portainer]      install : DONE!"                          && \
echo -e "\e[33m[Portainer] deployed at $IP:9000\n\n"                      || \
instPortainer=1 && echo -e "\n\n\e[31m[Portainer]      install : FAILED!" && \
echo -e "\n\n" 

#Pulll all images
sudo docker pull organizr/organizr:latest        && echo -e "\e[33m[Organizr]            pulled"
sudo docker pull jc21/nginx-proxy-manager:latest && echo -e "\e[33m[Nginx Proxy Manager] pulled"

echo -e "\e[33mReady to start!"
echo -e "\e[33mCreating directories"
mkdir ~/organizr   && echo -e "\e[33m[organizr]   folder created" || echo -e "\e[31m[organizr] folder cannot be created... it exists?"
mkdir ~/nginxproxy && echo -e "\e[33m[nginxproxy] folder created" || echo -e "\e[31m[nginxproxy] folder cannot be created... it exists?"

echo "Deploying Docker containers..."
cp organizr-docker-compose.yml ~/organizr/docker-compose.yml      || echo -e "\e[31m[organizr] yml cannot be created... it doesn't exist?"
cp nginx-proxy-docker-compose.yml ~/nginxproxy/docker-compose.yml || echo -e "\e[31m[nginxproxy] yml cannot be created... it doesn't exist?"

cd ~/organizr && docker-compose up -d 
cd ~/nginxproxy && docker-compose up -d
echo -e "\e[33m[portainer] deployed at $IP:9000"
echo -e "\e[33m[organizr] deployed at $IP:88"
echo -e "\e[33m[nginxproxy] deployed at $IP:181. \n Your IP is $IP. Port-forward port 80 and 443 to $IP:180 and $IP:1443"

echo -e "\e[33mALL DONE! Check running containers..."
docker ps
exit
