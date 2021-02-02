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
options=(1 "Docker & Docker Compose" off    # any option can be set to default to "on"
         2 "RClone - mount your GDrive One Drive MEGA AWS WEBDav etc" off
         3 "[Docker] Portainer - manage containers" off
         4 "[Docker] NginxProxyManager - reverse-proxy your containers" off
         5 "[Docker] Organizr - your personal start page" off
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



echo -e "\e[32mALL DONE! 
Check running containers..."
docker ps

if [ instDocker=1 ];then 
  echo -e "\e[32m[INSTALLED] \e[33m[Docker]\e[39m can be run by using 
             \e[33mdocker run -d --name something -p hostportno:containerport -v hostdir:containerdir repo/container\e[39m 
             then open up browser at \e[34m$IP:HostPortNo\e[39m" 
fi

if [ instDockerCompose=1 ];then
  echo -e "\e[32m[INSTALLED] \e[33m[Docker Compose]\e[39m can be run by 
             editing your \e[33mdocker-compose.yml\e[39m file, then do 
             \e[33mdocker-compose up -d\e[39m to start, or 
             \e[33mdocker-compose down --rmi local\e[39m to uninstall and remove container"
fi

if [ instRClone=1 ];then
  echo -e "\e[32m[INSTALLED] \e[33m[RClone]\e[39m can be run by using
             \e[33mrclone config\e[39m, and then \e[33mrclone cp\e[39m, \e[33mrclone mv\e[39m, 
             \e[33mrclone lsd\e[39m, \e[33mrclone ls\e[39m, \e[33mrclone mount\e[39m."
fi

if [ instPortainer=1 ];then
  echo -e "\e[32m[INSTALLED] \e[33m[portainer]\e[39m deployed at \e[34m$IP:9000\e[39m."
fi

if [ instNginxProxy=1 ];then
  echo -e "\e[32m[INSTALLED] \e[33m[nginx-proxy-manager]\e[39m deployed at \e[34m$IP:181\e[39m.  
             Your IP is \e[34m$IP\e[39m.  
             Port-forward/Add virtual server port 80 and 443 to \e[34m$IP:180\e[39m and \e[34m$IP:1443\e[39m   
             from inside your router's WebUI page,  usually at   
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi

if [ instOrganizr=1 ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[organizr]\e[39m deployed at \e[34m$IP:88\e[39m.   
             Port-forward/Add virtual server   
             port \e[34m80\e[39m to \e[34m$IP:88\e[39m  
             from inside your router's WebUI page, usually at  
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi 
exit
