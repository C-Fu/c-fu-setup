#!/bin/bash

#######################################
## Name: pi-setup script             ##
## Author: C-Fu adri.mcmc@gmail.com  ##
## Description: Automate fresh pi    ##
##   installs, make it easier to     ##
##   find common containers          ##
##   compatible for arm/pi and x86   ##
##   Containers are cross-platform   ##
##                                   ##
## Note: Code designed for           ##
##   ultra-wide monitors, sorry!     ##
#######################################


clear

echo -e "\e[7m\n\n
[----------------------------------------------------]
[------------------ Pi Setup Script------------------]
[------------------- \e[7mby C-Fu--------------------]
[----Make sure to git clone to \$HOME/c-fu-setup!----]
[----------------------------------------------------]
\e[0m"

sleep 3
clear

#Reset vars
instDocker="NO"
instDockerCompose="NO"
instRClone="NO"
instAfraid="NO"
instPortainer="NO"
instNginxProxy="NO"
instOrganizr="NO"
instWordpress="NO"
instRadarr="NO"
instSonarr="NO"
instLidarr="NO"
instJackett="NO"
instruTorrent="NO"
instNavidrome="NO"
instNextcloudpi="NO"
instOverseerr="NO"

#init vars"
scriptDir="$HOME/c-fu-setup"
IP=`hostname  -I | cut -f1 -d' '` #get first IP

containerName="hello-world"
containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
containerRepo= #nothing



cmd=(dialog --separate-output 
     --title "C-Fu's Setup script for common apps"
     --checklist "Select software to install/update:
     (WARNING: DO NOT RE-INSTALL DOCKER & DOCKER-COMPOSE THIS WAY!
     Docker - Containerize your apps, it's the future!
     RClone - mount your cloud storage easily
     Afraid.org - set up a quick cron job, get your DDNS url+key first!
     Portainer - manage your container the pro way
     NginxProxyManager - add ssl to your DDNS!
     Organizr - your personal start page to all of your web apps
     WordPress - host your site from your house!
     Radarr - organize your Movie files
     Sonarr - organize your TVShows files
     Lidarr - organize your Music files
     Jackett - organize your media sources
     ruTorrent - Torrent downloader for *arr+Jackett
     Navidrome - web-based music player
	 Nextcloudpi - awesome office collaboration suite
	 Overseerr - Request your movies & tv shows from here
     " 40 80 61
    )
options=(1  "Docker & Docker Compose" off    # any option can be set to default to "on"
         2  "RClone - mount your GDrive One Drive MEGA AWS WEBDav etc"   off
         3  "Afraid.org - stupidly simple & free DDNS url! (soon!)"      off
         4  "[Docker] Portainer - manage containers"                     off
         5  "[Docker] NginxProxyManager - reverse-proxy your containers" off
         6  "[Docker] Organizr - your personal start page"               off
         7  "[Docker] WordPress - biggest site creator"                  off
         8  "[Docker] Radarr - your movie organizer "                    off
         9  "[Docker] Sonarr - your tv shows organizer "                 off
         10 "[Docker] Lidarr - your music organizer "                    off
         11 "[Docker] Jackett - your media download finder"              off
         12 "[Docker] ruTorrent - your Torrent downloader "              off
         13 "[Docker] Navidrome - web-based music player & server"       off
		 14 "[Docker] NextCloudPi - awesome office collaboration suite"  off
         15 "[Docker] Overseerr - media requests management"             off
         )
         
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear



for choice in $choices
do
    case $choice in
        1)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [ Installing Docker & Docker Compose ]
            [------------------------------------]
            "
            #Install docker
            curl -fsSL https://get.docker.com -o get-docker.sh && instDocker=YES      || echo -e "Error! Did not get docker script!"    && instDocker=NO
            sudo sh get-docker.sh                              && instDocker=YES      || echo -e "Error! Did not run script!"           && instDocker=NO
            sudo usermod -aG docker pi || sudo usermod -aG docker dietpi #just in case
            #Install docker-compose
            sudo apt install -y libffi-dev libssl-dev 
            sudo apt install -y python3 python3-pip
            sudo apt remove  -y python-configparser #not needed
            echo -e "\e[33mInstalling Docker Compose. Will take some time..."
            sudo pip3 -v install docker-compose && instDockerCompose=YES              || echo -e "Error! Did not install docker-compose!" && instDockerCompose=NO
            echo -e "\n\n"
            if [ "$instDocker"="YES" ]; then
                echo -e "\e[33m[Docker] install         : DONE!"
            else
                echo -e "\e[31m[Docker] install         : FAILED!"
            fi
            if [ "$instDockerCompose"="YES" ]; then
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
            curl https://rclone.org/install.sh | sudo bash       && instRClone=YES    || echo -e "\e[31mError! Did not download RClone! Check your Internet connection! "     && instRClone=NO 
            echo -e "\n\n"   
            if [ "$instRClone"="YES" ]; then
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
            [     Installing afraid.org DDNS     ]
            [------------------------------------]
            "
            #Probably later...
            sleep 2
            ;;
        4)
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
               -v portainer_data:/data portainer/portainer-ce && instPortainer=YES || echo -e "\e[31mError! Portainer cannot be installed! " && instPortainer=NO

            if [ "$instPortainer"="YES" ]; then
                echo -e "\e[33m[Portainer] install : DONE!\n\e[33m[Portainer] deployed at $IP:9000"
            else
                echo -e "\e[31m[Portainer] install : FAILED!"
            fi
            echo -e "\n\n" 
            sleep 2
            ;;
        5)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [    Installing NginxProxyManager    ]
            [------------------------------------]
            "
            ## Only need to change $containerName and $containerRepo and repeat copy.. hopefully
            containerName="nginx-proxy-manager"
            containerRepo="jc21/"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            ## Set installVar to whatever inst$containerNiceName value is
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
        7)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [        Installing WordPress        ]
            [------------------------------------]
            "
            ##Only need to change $containerName and $containerRepo and repeat copy.. hopefully
            containerName="wordpress"
            containerName2="mariadb"
            containerRepo=
            containerRepo2="ghcr.io/linuxserver/"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            #set installVar to whatever inst$containerNiceName value is
            declare -n installVar=inst$containerNiceName
            echo -e "Pulling from $containerRepo$containerName..."
            
            ###Begin###
            docker pull "$containerRepo$containerName" && docker pull "$containerRepo2$containerName2" \ ## WordPress needs two containers!
            echo -e "\e[33m[$containerNiceName]\e[39m pulled"                                   || echo -e "\e[31m[$containerNiceName] cannot be downloaded!\e[39m"
            echo -e "\e[33mCreating $containerName container directories from inside $HOME\e[39m"
            mkdir ~/$containerName && echo -e "\e[33m[$containerNiceName]\e[39m folder created" || echo -e "\e[31m[$containerNiceName] folder cannot be created... it exists?\e[39m"
            cp $scriptDir/$containerName-docker-compose.yml ~/$containerName/docker-compose.yml || echo -e "\e[31m[$containerNiceName] yml cannot be created... it doesn't exist?\e[39m"
            cd ~/$containerName && docker-compose up -d && installVar="YES"                     || echo -e "\e[31m[$containerNiceName] container cannot be started! Check docker-compose.yml!\e[39m"
            if [ "$installVar"="YES" ]; then
                echo -e "\e[33m[$containerNiceName]\e[39m is UP!\n\e[33m[$containerName]\e[39m deployed!"
            else
                echo -e "\e[31m[$containerNiceName] cannot be started! Check the docker-compose file!\e[39m" 
            fi
            declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            instWordpress="YES"
            echo "instWordpress=$instWordpress"
            sleep 2
            ;;
        8)
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
            #declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;          
        9)
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
            #declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        10)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [          Installing Lidarr         ]
            [------------------------------------]
            "
            ##Only need to change $containerName and $containerRepo and repeat copy.. hopefully
            containerName="lidarr"
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
            #declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        11)
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
            #declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        12)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [        Installing ruTorrent        ]
            [------------------------------------]
            "
            #instJackett="NO" #temp
            ###Assign variables and indirect variables###
            containerName="rutorrent"
            containerNiceName="ruTorrent"
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
            #declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        13)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [        Installing Navidrome        ]
            [------------------------------------]
            "
            #instJackett="NO" #temp
            ###Assign variables and indirect variables###
            containerName="navidrome"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            containerRepo="deluan/"
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
            #declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        14)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [       Installing NextCloudPi       ]
            [------------------------------------]
            "
            #instJackett="NO" #temp
            ###Assign variables and indirect variables###
            containerName="nextcloudpi"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            containerRepo="ownyourbits/"
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
            #declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
            sleep 2
            ;;
        15)
            echo -e "\n\n\e[33m
            [------------------------------------]
            [        Installing Overseerr        ]
            [------------------------------------]
            "
            #instJackett="NO" #temp
            ###Assign variables and indirect variables###
            containerName="overseerr"
            containerNiceName="$(tr '[:lower:]' '[:upper:]' <<< ${containerName:0:1})${containerName:1}"
            containerRepo="hotio/"
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
            #declare -n installVar=t #some random shit, aka undeclaring? unlinking? I have no idea what I'm doing lel
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
echo "instDocker=        $instDocker"
echo "instDockerCompose= $instDockerCompose"
echo "instRClone=        $instRClone"
echo "instPortainer=     $instPortainer"
echo "instNginxProxy=    $instNginxProxy"
echo "instOrganizr=      $instOrganizr"
echo "instWordpress=     $instWordpress"
echo "instRadarr=        $instRadarr"
echo "instSonarr=        $instSonarr"
echo "instLidarr=        $instLidarr"
echo "instJackett=       $instJackett"
echo "instruTorrent=     $instruTorrent"


#SCRIPT CHECK AND INFO DISPLAY

###Docker###
if [ "instDocker" = "YES" ] ; then 
  echo -e "\e[32m[INSTALLED] \e[33m[Docker]\e[39m can be run by using 
            \e[33mdocker run -d --name something \\
            -p hostportno:containerport \\
            -v hostdir:containerdir \\
            repo/container\e[39m (one line)
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
if [ "$instPortainer" = "YES" ];then
  echo -e "\e[32m[INSTALLED] \e[33m[portainer]\e[39m deployed at \e[34m$IP:9000\e[39m."
fi

###NginxProxyManager###
if [ "$instNginxproxymanager" = "YES" ];then
  echo -e "\e[32m[INSTALLED] \e[33m[nginx-proxy-manager]\e[39m deployed at \e[34m$IP:181\e[39m.  
             Your IP is \e[34m$IP\e[39m.  
             Port-forward/Add virtual server port 80 and 443 to \e[34m$IP:180\e[39m and \e[34m$IP:1443\e[39m   
             from inside your router's WebUI page,  usually at   
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m."
fi

###Organizr###
if [ "$instOrganizr" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[organizr]\e[39m deployed at \e[34m$IP:88\e[39m.   
             This should/can be your front page, to access other services like 
             WordPress at $IP:8484 and NginxProxyManager WebUI at $IP:181.
             Port-forward/Add virtual server   
             port \e[34m88\e[39m to \e[34m$IP:88\e[39m  
             from inside your router's WebUI page, usually at  
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m.
             Then use NginxProxyManager to set ssl at http://$IP:88 to your DDNS address.
             Free web address at afraid.org"
fi 

###WordPress###
if [ "$instWordpress" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[wordpress]\e[39m deployed at \e[34m$IP:8484\e[39m.   
             Port-forward/Add virtual server   
             port \e[34m8484\e[39m to \e[34m$IP:8484\e[39m  
             from inside your router's WebUI page, usually at  
             \e[34m192.168.0.1 \e[39mor \e[34m192.168.1.1 \e[39mor \e[34m192.168.0.254\e[39m.
             "
fi 

###Radarr###
if [ "$instRadarr" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[Radarr]\e[39m deployed at \e[34m$IP:7878\e[39m.
              Works best with Sonarr and Lidarr and Jackett and a Downloader, like ruTorrent"
fi

###Sonarr###
if [ "$instSonarr" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[Sonarr]\e[39m deployed at \e[34m$IP:8989\e[39m.   
             Works best with Radarr and Lidarr and Jackett and a Downloader, like ruTorrent"
fi

###Lidarr###
if [ "$instLidarr" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[Lidarr]\e[39m deployed at \e[34m$IP:8686\e[39m.   
             Works best with Sonarr and Radarr and Jackett and a Downloader, like ruTorrent"
fi

###Jackett###
if [ "$instJackett" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[Jackett]\e[39m deployed at \e[34m$IP:9117\e[39m.
             Works best with Sonarr and Radarr and Lidarr and a Downloader, like ruTorrent"  
fi

###ruTorrent###
if [ "instruTorrent" = "1" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[ruTorrent]\e[39m deployed at \e[34m$IP:580\e[39m.   
             Port-forward/Add virtual server for these ports:            
             \e[34m5000\e[39m  - scgi port
             \e[34m56881\e[39m - tcp&udp port for downloading
             \e[34m580\e[39m   - WebUI port, not necessary unless you want public access (DANGER!)
             Access via web browser at \e[34m$IP:580\e[39m" 
fi

if [ "$instNextcloudpi" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[NextCloudPi]\e[39m deployed at \e[34m$IP:44443\e[39m.
             Visit \e[34m$IP:44443\e[39m to set up your NCP before going to \e[34m$IP:4443\e[39m"  
fi

if [ "$instOverseerr" = "YES" ]; then
  echo -e "\e[32m[INSTALLED] \e[33m[Overseerr]\e[39m deployed at \e[34m$IP:5055\e[39m."  
fi

exit
