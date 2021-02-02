#!/bin/bash

#######################################
## Name: pi-setup script             ##
## Author: C-Fu adri.mcmc@gmail.com  ##
## Description: Automate fresh pi    ##
##   installs, make it easier to     ##
##   find common containers          ##
##   suitable for arm/pi             ##
##                                   ##
## Note: Code designed for           ##
##   ultra-wide monitors, sorry!     ##
#######################################


IP=`hostname  -I | cut -f1 -d' '`
clear
TITLE="\e[5m\n\n\n[--------------------------------------]\n[----------- \e[7mPi Setup Script\e[0m-----------]\n[---------------- \e[7mby C-Fu\e[0m--------------]\n[--------------------------------------]\n\e[0m"
echo -e $TITLE

sleep 3
clear

cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "Docker & Docker Compose - containerize your applications" off    # any option can be set to default to "on"
         2 "RClone - mount your cloud storage - GDrive, One Drive, MEGA, AWS, WEBDav, etc" off
         3 "[Docker] Portainer" off
         4 "[Docker] NginxProxyManager" off
         5 "[Docker] Organizr" off
         6 "[Docker] WordPress (Not yet)" off)
         
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

for choice in $choices
do
    case $choice in
        1)
            echo -e "\n\n\e[33m[------------------------------------]\n[ Installing Docker & Docker Compose ]\n[------------------------------------]"
            #Install docker
            curl -fsSL https://get.docker.com -o get-docker.sh && instDocker=1      || echo -e "Error! Could not get docker script!" 										&& instDocker=0
            sudo sh get-docker.sh                              && instDocker=1      || echo -e "Error! Could not run script!" 												&& instDocker=0
            sudo usermod -aG docker pi || sudo usermod -aG docker dietpi #just in case
            #Install docker-compose
            sudo apt install -y libffi-dev libssl-dev 
            sudo apt install -y python3 python3-pip
            sudo apt remove  -y python-configparser #not needed
            echo -e "\e[33mInstalling Docker Compose. Will take some time..."
            sudo pip3 -v install docker-compose && instDockerCompose=1              || echo -e "Error! Could not install docker-compose!" 									&& instDockerCompose=0
            echo -e "\n\n"
            if [ "$instDocker"="1" ]; then
                echo -e "\e[33m[Docker] install         : DONE!"
            else
                echo -e "\e[31m[Docker] install         : FAILED!"
            fi
            if [ "$instDockerCompose"="1" ]; then
                echo -e "\e[33m[Docker Compose] install : DONE!"
            else
                echo -e "\e[31m[Docker Compose] install : FAILED!"
            fi
            echo -e "\n\n"
            ;;
        2)
            echo -e "\n\n\e[33m[------------------------------------]\n[          Installing RClone         ]\n[------------------------------------]"
            #Install rclone
            echo "\e[33mInstalling rclone..."
            curl https://rclone.org/install.sh | sudo bash       && instRClone=1    || echo -e "\e[31mError! Could not download RClone! Check your Internet connection! " 	&& instRClone=0 
            echo -e "\n\n"   
            if [ "$instRClone"="1" ]; then
                echo -e "\e[33m[RClone] install : DONE!"
            else
                echo -e "\e[31m[RClone] install : FAILED!"
            fi
            echo -e "\n\n"
            ;; 
        3)
            echo -e "\n\n\e[33m[------------------------------------]\n[        Installing Portainer        ]\n[------------------------------------]"
            #Install Portainer
            docker run -d                   				\
              --name=portainer 								\
              --restart=always								\
              -p 8000:8000 									\
              -p 9000:9000 									\
               -v /var/run/docker.sock:/var/run/docker.sock \
               -v portainer_data:/data portainer/portainer-ce && instPortainer=1 || echo -e "\e[31mError! Portainer cannot be installed! " 									&& instPortainer=0

            if [ "$instPortainer"="1" ]; then
                echo -e "\e[33m[Portainer] install : DONE!\n\e[33m[Portainer] deployed at $IP:9000"
            else
                echo -e "\e[31m[Portainer] install : FAILED!"
            fi
            echo -e "\n\n" 
            ;;
        4)
            echo -e "\n\n\e[33m[------------------------------------]\n[    Installing NginxProxyManager    ]\n[------------------------------------]"
            sudo docker pull jc21/nginx-proxy-manager:latest && echo -e "\e[33m[Nginx Proxy Manager] pulled" || echo -e "\e[31m[NginxProxyManager] cannot be downloaded!"   && instNginxProxy=0
            echo -e "\e[33mCreating NginxProxyManager container directories from inside $PWD"
            mkdir ~/nginxproxy && echo -e "\e[33m[nginxproxy] folder created"   || echo -e "\e[31m[nginxproxy] folder cannot be created... it exists?"                      && instNginxProxy=0
            cp nginx-proxy-docker-compose.yml ~/nginxproxy/docker-compose.yml   || echo -e "\e[31m[nginxproxy] yml cannot be created... it doesn't exist?"                  && instNginxProxy=0
            cd ~/nginxproxy && docker-compose up -d && instNginxProxy=1         || echo -e "\e[31m[nginxproxy] container cannot be started! Check docker-compose.yml!"      && instNginxProxy=0
            if [ "$instNginxProxy"="1" ]; then
                echo -e "\e[33m[NginxProxyManager] is UP!\n[nginxproxy] deployed - View via browser at $IP:181. \n Your IP is $IP. Port-forward/Add virtual server port 80 and 443 to $IP:180 and $IP:1443 \nfrom inside your router's WebUI page \nUsually at 192.168.0.1 or 192.168.1.1 or 192.168.0.254"
            else
                echo -e "\e[31m[NginxProxyManager] cannot be started! Check the docker-compose file!" 
            fi
            ;;
        5)
            echo -e "\n\n\e[33m[------------------------------------]\n[        Installing Organizr         ]\n[------------------------------------]"
            sudo docker pull organizr/organizr:latest        && echo -e "\e[33m[Organizr]            pulled" || echo -e "\e[31m[NginxProxyManager] cannot be downloaded!"   && instOrganizr=0
            echo -e "\e[33mCreating container directories from inside $PWD"
            mkdir ~/organizr   && echo -e "\e[33m[organizr]   folder created"   || echo -e "\e[31m[organizr] folder cannot be created... it exists?"                        && instOrganizr=0
            cp organizr-docker-compose.yml ~/organizr/docker-compose.yml        || echo -e "\e[31m[organizr] yml cannot be created... it doesn't exist?"
            cd ~/organizr && docker-compose up -d && instOrganizr=1             || echo -e "\e[31m[organizr] container cannot be started! Check docker-compose.yml!"        && instOrganizr=0
            if [ "$instOrganizr"="1" ]; then
                echo -e "\e[33m[Organizr] is UP!\n[organizr] deployed - View via browser at $IP:88. \n Your IP is $IP. Port-forward/Add virtual server port 80 to $IP:88  \nfrom inside your router's WebUI page \nUsually at 192.168.0.1 or 192.168.1.1 or 192.168.0.254"
            else
                echo -e "\e[31m[Organizr] cannot be started! Check the docker-compose file!" 
            fi
            ;;
    esac
done



echo -e "\e[33mALL DONE! Check running containers..."
docker ps

if [ instDocker=1 ];then 
                    echo -e "\e[32m[INSTALLED] \e[33m[Docker] can be run by using docker run -d --name something -p hostportno:containerport -v hostdir:containerdir repo/container then open up browser at $PWD:HostPortNo" 
fi

if [ instDockerCompose=1 ];then
                    echo -e "\e[32m[INSTALLED] \e[33m[Docker Compose] can be run by editing your docker-compose.yml file, then do docker-compose up -d or uninstall container by docker-compose down --rmi local"
fi

if [ instRClone=1 ];then
                    echo -e "\e[32m[INSTALLED] \e[33m[RClone] can be run by using rclone config, and then rclone cp, rclone lsd, rclone ls, rclone mount."
fi

if [ instPortainer=1 ];then
                    echo -e "\e[32m[INSTALLED] \e[33m[portainer] deployed at $IP:9000"
fi

if [ instNginxProxy=1 ];then
                    echo -e "\e[32m[INSTALLED] \e[33m[nginx-proxy-manager] deployed at $IP:181. \n Your IP is $IP. Port-forward/Add virtual server port 80 and 443 to $IP:180 and $IP:1443 \nfrom inside your router's WebUI page \nUsually at 192.168.0.1 or 192.168.1.1 or 192.168.0.254"
fi

if [ instOrganizr=1 ]; then
                    echo -e "\e[32m[INSTALLED] \e[33m[organizr] deployed at $IP:88. Port-forward/Add virtual server port 80 to $IP:88  \nfrom inside your router's WebUI page \nUsually at 192.168.0.1 or 192.168.1.1 or 192.168.0.254"
fi 
exit
