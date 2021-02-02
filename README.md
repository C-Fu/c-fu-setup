# c-fu-setup
Collection of basic pi setup - docker, portainer, etc.
Except for docker, all of the containers are cross-platform - x86 and ARM friendly! And are regularly maintained.

Current software list:

- Docker | Containerize your apps
- Docker Compose | Easily spin up and down your containers, as well as to help ease migration
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


Just run the pi-setup.sh script:

```
cd ~
git clone https://github.com/C-Fu/c-fu-setup.git
cd pi-setup
sudo chmod +x pi-setup.sh
sudo ./pi-setup.sh
```
