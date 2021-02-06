# C-Fu's Setup script
Collection of basic app setup - docker, portainer, sonarr, nextcloudpi, etc.
Except for docker, all(most) of the containers are cross-platform - x86 and ARM friendly! And are regularly maintained.

**Supported architecture: x64, arm (and x86?)

Current software list:

| Service Name       | Description     | Ports/Command     |
| :------------- | :----------: | -----------: |
| Docker | containerize your apps | docker run -d --name something -p hostPort:containerPort -v /host/dir:/container/dir repoName/containerName |
| Docker Compose | easily spin up and down your containers, as well as to help ease migration | docker-compose up -d, docker-compose down --rmi local |
| RClone | mount your cloud storage easily | rclone config|
| Portainer | manage your container the pro way | 9000:9000, view at hostname.local:9000/ | 
| Nginx Proxy Manager | add ssl to your DDNS url! | 181:81 (web), port-forward 80 & 443 to 180 & 1443 in router |
| Organizr | your personal start page to all of your web apps | hostname.local:88/ |
| Wordpress | host your blog/site from your house! | hostname.local:8484/ |
| Radarr | organize your Movie files | hostname.local:7878/ |
| Sonarr | organize your TVShows files | hostname.local:8989/ |
| Lidarr | organize your Music files | hostname.local:8686/ |
| Jackett | organize your media sources | hostname.local:9117/ |
| ruTorrent | torrent downloader for \*arr+Jackett | hostname.local:580/ port-forward 5000 & 56881tcp & 56881udp |
| Afraid.org | set up a quick cron job, but get your DDNS url+key first! | Just get your DDNS key and it'll be added to crontab & run every 5 mins |
| Navidrome | web-based music player and server, works with ultrasonic (Android) and iSub (iPhone) | localhost.local:4533 |
| NextCloudPi | awesome web-based office collaboration tool, with cloud storage support & sharing! | hostname.local:44443 to begin setup, https://hostname.local:4443 to start |
| Overseerr | request your movies & tv shows from here | hostname.local:5055
| Dozzle | web-based, very lightweight docker logs viewer for all of your containers | hostname.local:9999 |


Once you've downloaded this git repo, be sure to check the corresponding docker-compose.yml file before executing pi-setup.sh. 
## You might want/need to change it, especially the environment parameters. 
Example:


```
$ cd $HOME/c-fu-setup
~/c-fu-setup$ cat wordpress-docker-compose.yml
.
.
.
      WORDPRESS_DB_USER: exampleuser
      WORDPRESS_DB_PASSWORD: examplepass
      WORDPRESS_DB_NAME: wpdb
.
.
.
```

You can set up the mysql's user password from here.

## Docker network notes:
For organizational purposes, currently the containers are put in several networks:
- media_net : For media-based containers, like ruTorrent, Sonarr, Jackett
- web_net : For general web-based apps, like nextcloudpi, Wordpress and NginxProxyManager

## Installation instruction

Just run the pi-setup.sh script:

```
cd $HOME
git clone https://github.com/C-Fu/c-fu-setup.git
cd c-fu-setup
chmod +x c-fu-setup.sh
## Be sure to check the *-docker-compose.yml file and edit if necessary
bash c-fu-setup.sh
```
