#!/bin/bash

#######################################
## Name: pi-setup script             ##
## Author: C-Fu adri.mcmc@gmail.com  ##
## Description: Automate fresh pi    ##
##   installs, make it easier to     ##
##   find common containers          ##
##   suitable for arm/pi             ##
##   Containers are cross-platform   ##
##                                   ##
## Note: Code designed for           ##
##   ultra-wide monitors, sorry!     ##
#######################################


IP=`hostname  -I | cut -f1 -d' '`
clear

echo -e "\e[5m\n\n
[--------------------------------------]
[----------- \e[7mPi Setup Script\e[0m-----------]
[---------------- \e[7mby C-Fu\e[0m--------------]
[--------------------------------------]
\e[0m"

sleep 2
clear
#Clear vars
instDocker=NO
instDockerCompose=NO
instRClone=NO
instPortainer=NO
instNginxProxy=NO
instOrganizr=NO
instWordPress=NO
instRadarr=NO
instSonarr=NO
instJackett=NO
instruTorrent=NO

containerName="hello-world"
containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
containerRepo="."


cmd=(dialog --separate-output 
     --title "C-Fu's Pi setup script for common apps"
     --checklist "Select software to install/update:
     (WARNING: DO NOT RE-INSTALL DOCKER & DOCKER-COMPOSE THIS WAY!
     Docker - Containerize your apps, it's the future!
     RClone - mount your cloud storage easily
     Portainer - manage your container the pro way
     NginxProxyManager - add ssl to your DDNS!
     Organizr - your personal start page to all of your web apps
     WordPress - host your site from your house!
     " 40 80 61
    )
options=(1  "Docker & Docker Compose" off    # any option can be set to default to "on"
         2  "RClone - mount your GDrive One Drive MEGA AWS WEBDav etc" off
         3  "[Docker] Portainer - manage containers" off
         4  "[Docker] NginxProxyManager - reverse-proxy your containers" off
         5  "[Docker] Organizr - your personal start page" off
         6  "[Docker] WordPress (Not yet)" off
         7  "[Docker] Radarr - your movie organizer " off
         8  "[Docker] Sonarr - your tv shows organizer " off
         9  "[Docker] Jackett - your media download finder" off
         10 "[Docker] ruTorrent - your Torrent downloader " off
         )
         
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear



for choice in $choices
do
    case $choice in
        1)
            echo -e "\n\n\e[33m[------------------------------------]\n[ Installing Docker & Docker Compose ]\n[------------------------------------]"
            #Install docker
            curl -fsSL https://get.docker.com -o get-docker.sh && instDocker=1      || echo -e "Error! Did not get docker script!"                                      && instDocker=0
            sudo sh get-docker.sh                              && instDocker=1      || echo -e "Error! Did not run script!"                                                 && instDocker=0
            sudo usermod -aG docker pi || sudo usermod -aG docker dietpi #just in case
            #Install docker-compose
            sudo apt install -y libffi-dev libssl-dev 
            sudo apt install -y python3 python3-pip
            sudo apt remove  -y python-configparser #not needed
            echo -e "\e[33mInstalling Docker Compose. Will take some time..."
            sudo pip3 -v install docker-compose && instDockerCompose=1              || echo -e "Error! Did not install docker-compose!"                                     && instDockerCompose=0
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
            sleep 2
            ;;
        2)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [          Installing RClone         ]
            [------------------------------------]
            "
            #Install rclone
            echo "\e[33mInstalling rclone..."
            curl https://rclone.org/install.sh | sudo bash       && instRClone=1    || echo -e "\e[31mError! Did not download RClone! Check your Internet connection! "     && instRClone=0 
            echo -e "\n\n"   
            if [ "$instRClone"="1" ]; then
                echo -e "\e[33m[RClone] install : DONE!"
            else
                echo -e "\e[31m[RClone] install : FAILED!"
            fi
            echo -e "\n\n"
            sleep 2
            ;; 
        3)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [        Installing Portainer        ]
            [------------------------------------]
            "
            #Install Portainer
            docker run -d                                   \
              --name=portainer                              \
              --restart=always                              \
              -p 8000:8000                                  \
              -p 9000:9000                                  \
               -v /var/run/docker.sock:/var/run/docker.sock \
               -v portainer_data:/data portainer/portainer-ce && instPortainer=1 || echo -e "\e[31mError! Portainer cannot be installed! "                                  && instPortainer=0

            if [ "$instPortainer"="1" ]; then
                echo -e "\e[33m[Portainer] install : DONE!\n\e[33m[Portainer] deployed at $IP:9000"
            else
                echo -e "\e[31m[Portainer] install : FAILED!"
            fi
            echo -e "\n\n" 
            sleep 2
            ;;
        4)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [    Installing NginxProxyManager    ]
            [------------------------------------]
            "
            ##Only need to change $containerName and $containerRepo and repeat copy.. hopefully
            containerName="nginx-proxy-manager"
            containerRepo="jc21/"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            #set installVar to whatever inst$containerNiceName value is
            declare -n installVar=inst$containerNiceName
            
            ###Begin###
            docker pull "$containerRepo$containerName" && \
            echo -e "\e[33m[$containerNiceName]\e[39m pulled"                                   || echo -e "\e[31m[$containerNiceName] cannot be downloaded!\e[39m"
            echo -e "\e[33mCreating container directories from inside $HOME\e[39m"
            mkdir ~/$containerName && echo -e "\e[33m[$containerNiceName]\e[39m folder created" || echo -e "\e[31m[$containerNiceName] folder cannot be created... it exists?\e[39m"
            cp $containerName-docker-compose.yml ~/$containerName/docker-compose.yml            || echo -e "\e[31m[$containerNiceName] yml cannot be created... it doesn't exist?\e[39m"
            cd ~/$containerName && docker-compose up -d && installVar="YES"                     || echo -e "\e[31m[$containerNiceName] container cannot be started! Check docker-compose.yml!\e[39m"
            if [ "$installVar"="YES" ]; then
                echo -e "\e[33m[$containerNiceName]\e[39m is UP!\n\e[33m[$containerName]\e[39m deployed!"
            else
                echo -e "\e[31m[$containerNiceName] cannot be started! Check the docker-compose file!\e[39m" 
            fi
            declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        5)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [        Installing Organizr         ]
            [------------------------------------]
            "
            ##Only need to change $containerName and $containerRepo and repeat copy.. hopefully
            containerName="organizr"
            containerRepo="organizr/"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            #set installVar to whatever inst$containerNiceName value is
            declare -n installVar=inst$containerNiceName
            
            ###Begin###
            docker pull "$containerRepo$containerName" && \
            echo -e "\e[33m[$containerNiceName]\e[39m pulled"                                   || echo -e "\e[31m[$containerNiceName] cannot be downloaded!\e[39m"
            echo -e "\e[33mCreating container directories from inside $HOME\e[39m"
            mkdir ~/$containerName && echo -e "\e[33m[$containerNiceName]\e[39m folder created" || echo -e "\e[31m[$containerNiceName] folder cannot be created... it exists?\e[39m"
            cp $containerName-docker-compose.yml ~/$containerName/docker-compose.yml            || echo -e "\e[31m[$containerNiceName] yml cannot be created... it doesn't exist?\e[39m"
            cd ~/$containerName && docker-compose up -d && installVar="YES"                     || echo -e "\e[31m[$containerNiceName] container cannot be started! Check docker-compose.yml!\e[39m"
            if [ "$installVar"="YES" ]; then
                echo -e "\e[33m[$containerNiceName]\e[39m is UP!\n\e[33m[$containerName]\e[39m deployed!"
            else
                echo -e "\e[31m[$containerNiceName] cannot be started! Check the docker-compose file!\e[39m" 
            fi
            declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        6)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [        Installing WordPress        ]
            [------------------------------------]
            "
            ##Only need to change $containerName and $containerRepo and repeat copy.. hopefully
            containerName="wordpress"
            containerRepo=
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            #set installVar to whatever inst$containerNiceName value is
            declare -n installVar=inst$containerNiceName
            
            ###Begin###
            docker pull "$containerRepo$containerName" && \
            echo -e "\e[33m[$containerNiceName]\e[39m pulled"                                   || echo -e "\e[31m[$containerNiceName] cannot be downloaded!\e[39m"
            echo -e "\e[33mCreating container directories from inside $HOME\e[39m"
            mkdir ~/$containerName && echo -e "\e[33m[$containerNiceName]\e[39m folder created" || echo -e "\e[31m[$containerNiceName] folder cannot be created... it exists?\e[39m"
            cp $containerName-docker-compose.yml ~/$containerName/docker-compose.yml            || echo -e "\e[31m[$containerNiceName] yml cannot be created... it doesn't exist?\e[39m"
            cd ~/$containerName && docker-compose up -d && installVar="YES"                     || echo -e "\e[31m[$containerNiceName] container cannot be started! Check docker-compose.yml!\e[39m"
            if [ "$installVar"="YES" ]; then
                echo -e "\e[33m[$containerNiceName]\e[39m is UP!\n\e[33m[$containerName]\e[39m deployed!"
            else
                echo -e "\e[31m[$containerNiceName] cannot be started! Check the docker-compose file!\e[39m" 
            fi
            declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        7)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [          Installing Radarr         ]
            [------------------------------------]
            "
            ##Only need to change $containerName and $containerRepo and repeat copy.. hopefully
            containerName="radarr"
            containerRepo="ghcr.io/linuxserver/"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            #set installVar to whatever inst$containerNiceName value is
            declare -n installVar=inst$containerNiceName
            
            ###Begin###
            docker pull "$containerRepo$containerName" && \
            echo -e "\e[33m[$containerNiceName]\e[39m pulled"                                   || echo -e "\e[31m[$containerNiceName] cannot be downloaded!\e[39m"
            echo -e "\e[33mCreating container directories from inside $HOME\e[39m"
            mkdir ~/$containerName && echo -e "\e[33m[$containerNiceName]\e[39m folder created" || echo -e "\e[31m[$containerNiceName] folder cannot be created... it exists?\e[39m"
            cp $containerName-docker-compose.yml ~/$containerName/docker-compose.yml            || echo -e "\e[31m[$containerNiceName] yml cannot be created... it doesn't exist?\e[39m"
            cd ~/$containerName && docker-compose up -d && installVar="YES"                     || echo -e "\e[31m[$containerNiceName] container cannot be started! Check docker-compose.yml!\e[39m"
            if [ "$installVar"="YES" ]; then
                echo -e "\e[33m[$containerNiceName]\e[39m is UP!\n\e[33m[$containerName]\e[39m deployed!"
            else
                echo -e "\e[31m[$containerNiceName] cannot be started! Check the docker-compose file!\e[39m" 
            fi
            declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;          
        8)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [          Installing Sonarr         ]
            [------------------------------------]
            "
            ##Only need to change $containerName and $containerRepo and repeat copy.. hopefully
            containerName="sonarr"
            containerRepo="ghcr.io/linuxserver/"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            #set installVar to whatever inst$containerNiceName value is
            declare -n installVar=inst$containerNiceName
            
            ###Begin###
            docker pull "$containerRepo$containerName" && \
            echo -e "\e[33m[$containerNiceName]\e[39m pulled"                                   || echo -e "\e[31m[$containerNiceName] cannot be downloaded!\e[39m"
            echo -e "\e[33mCreating container directories from inside $HOME\e[39m"
            mkdir ~/$containerName && echo -e "\e[33m[$containerNiceName]\e[39m folder created" || echo -e "\e[31m[$containerNiceName] folder cannot be created... it exists?\e[39m"
            cp $containerName-docker-compose.yml ~/$containerName/docker-compose.yml            || echo -e "\e[31m[$containerNiceName] yml cannot be created... it doesn't exist?\e[39m"
            cd ~/$containerName && docker-compose up -d && installVar="YES"                     || echo -e "\e[31m[$containerNiceName] container cannot be started! Check docker-compose.yml!\e[39m"
            if [ "$installVar"="YES" ]; then
                echo -e "\e[33m[$containerNiceName]\e[39m is UP!\n\e[33m[$containerName]\e[39m deployed!"
            else
                echo -e "\e[31m[$containerNiceName] cannot be started! Check the docker-compose file!\e[39m" 
            fi
            declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        9)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [         Installing Jackett         ]
            [------------------------------------]
            "
            #instJackett="NO" #temp
            ###Assign variables and indirect variables###
            containerName="jackett"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            containerRepo="ghcr.io/linuxserver/"
            #set installVar to whatever inst$containerNiceName value is
            declare -n installVar=inst$containerNiceName
            
            ###Begin###
            docker pull "$containerRepo$containerName" && \
            echo -e "\e[33m[$containerNiceName]\e[39m pulled"                                   || echo -e "\e[31m[$containerNiceName] cannot be downloaded!\e[39m"
            echo -e "\e[33mCreating container directories from inside $HOME\e[39m"
            mkdir ~/$containerName && echo -e "\e[33m[$containerNiceName]\e[39m folder created" || echo -e "\e[31m[$containerNiceName] folder cannot be created... it exists?\e[39m"
            cp $containerName-docker-compose.yml ~/$containerName/docker-compose.yml            || echo -e "\e[31m[$containerNiceName] yml cannot be created... it doesn't exist?\e[39m"
            cd ~/$containerName && docker-compose up -d && installVar="YES"                     || echo -e "\e[31m[$containerNiceName] container cannot be started! Check docker-compose.yml!\e[39m"
            if [ "$installVar"="YES" ]; then
                echo -e "\e[33m[$containerNiceName]\e[39m is UP!\n\e[33m[$containerName]\e[39m deployed!"
            else
                echo -e "\e[31m[$containerNiceName] cannot be started! Check the docker-compose file!\e[39m" 
            fi
            declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
    esac
done

echo -e "\n\e[32m
[------------------------------------]
[              ALL DONE!             ] 
[  https://github.com/C-Fu/pi-setup  ]
[------------------------------------]
\e[39m\n"
#echo -e "\e[32mCheck running containers..."
#docker ps


#SCRIPT CHECK AND INFO DISPLAY

###Docker###
if [ "instDocker" = "YES" ] ; then 
  echo -e "\e[32m[INSTALLED] \e[33m[Docker]\e[39m can be run by using 
             \e[33mdocker run -d --name something -p hostportno:containerport 
             -v hostdir:containerdir repo/container\e[39m (one line)
             then open up browser at \e[34m$IP:HostPortNo\e[39m" 
fi

###Docker Compose###
if [ "instDockerCompose" = "YES" ];then
  echo -e "\e[32m[INSTALLED] \e[33m[Docker Compose]\e[39m can be run by 
             editing your \e[33mdocker-compose.yml\e[39m file, then do 
             \e[33mdocker-compose up -d\e[39m to start, or 
             \e[33mdocker-compose down --rmi local\e[39m to uninstall and remove container"
fi

###RClone###
if [ "instRClone" = "YES" ];then
  echo -e "\e[32m[INSTALLED] \e[33m[RClone]\e[39m can be run by using
             \e[33mrclone config\e[39m, and then \e[33mrclone cp\e[39m, \e[33mrclone mv\e[39m, 
             \e[33mrclone lsd\e[39m, \e[33mrclone ls\e[39m, \e[33mrclone mount\e[39m."
fi

###Portainer###
if [ "instPortainer" = "YES" ];then
  echo -e "\e[32m[INSTALLED] \e[33m[portainer]\e[39m deployed at \e[34m$IP:9000\e[39m."
fi

###NginxProxyManager###
if [ "instNginxProxy" = "YES" ];then
  echo -e "\e[32m[INSTALLED] \e[33m[nginx-proxy-manager]\e[39m deployed at \e[34m$IP:181\e[39m.  
             Your IP is \e[34m$IP\e[39m.  
             Port-forward/Add virtual server port 80 and 443 to \e[34m$IP:180\e[39m and \e[34m$IP:1443\e[39m   
             from inside your router's WebUI page,  usually at   
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi

###Organizr###
if [ "instOrganizr" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[organizr]\e[39m deployed at \e[34m$IP:88\e[39m.   
             Port-forward/Add virtual server   
             port \e[34m80\e[39m to \e[34m$IP:88\e[39m  
             from inside your router's WebUI page, usually at  
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi 

###WordPress###
if [ "instWordPress" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[wordpress]\e[39m deployed at \e[34m$IP:8484\e[39m.   
             Port-forward/Add virtual server   
             port \e[34m8484\e[39m to \e[34m$IP:8484\e[39m  
             from inside your router's WebUI page, usually at  
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi 

###Radarr###
if [ "instRadarr" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[Radarr]\e[39m deployed at \e[34m$IP:7878\e[39m.   
             Port-forward/Add virtual server   
             port \e[34m7878\e[39m to \e[34m$IP:7878\e[39m  
             from inside your router's WebUI page, usually at  
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi

###Sonarr###
if [ "instSonarr" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[Sonarr]\e[39m deployed at \e[34m$IP:8989\e[39m.   
             Port-forward/Add virtual server   
             port \e[34m8989\e[39m to \e[34m$IP:8989\e[39m  
             from inside your router's WebUI page, usually at  
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi

###Jackett###
if [ "$instJackett" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[Jackett]\e[39m deployed at \e[34m$IP:9117\e[39m."
else 
  echo "hi Jackett"   
fi

###ruTorrent###
if [ "instruTorrent" = "1" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[ruTorrent]\e[39m deployed at \e[34m$IP:8989\e[39m.   
             Port-forward/Add virtual server   
             port \e[34m8989\e[39m to \e[34m$IP:8989\e[39m  
             from inside your router's WebUI page, usually at  
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi

exit
