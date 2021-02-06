# C-Fu's Setup script
Collection of basic app setup - docker, portainer, sonarr, nextcloudpi, etc.
Except for docker, all(most) of the containers are cross-platform - x86 and ARM friendly! And are regularly maintained.

**Supported architecture: x64, arm (and x86?)

Current software list:

- Docker | containerize your apps
- Docker Compose | easily spin up and down your containers, as well as to help ease migration
- RClone | mount your cloud storage easily
- Portainer | manage your container the pro way
- Nginx Proxy Manager | add ssl to your DDNS url!
- Organizr | your personal start page to all of your web apps
- Wordpress | host your blog/site from your house!
- Radarr | organize your Movie files
- Sonarr | organize your TVShows files
- Lidarr | organize your Music files
- Jackett | organize your media sources
- ruTorrent | Torrent downloader for *arr+Jackett
- Afraid.org | set up a quick cron job, but get your DDNS url+key first!
- Navidrome | web-based music player and server, works with ultrasonic (Android) and iSub (iPhone)
- NextCloudPi | awesome web-based office collaboration tool, with cloud storage support & sharing!
- Overseerr | Request your movies & tv shows from here
- Dozzle | Web-based, very lightweight docker logs viewer for all of your containers

| Service Name       | Description     | Ports/Command     |
| :------------- | :----------: | -----------: |
|  Docker | containerize your apps   | docker run -d --name something -p hostPort:containerPort -v /host/dir:/container/dir repoName/containerName    |
| You Can Also   | Put Pipes In | Like this \| |

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
