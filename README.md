# pi-setup
Collection of basic pi setup - docker, portainer, etc.
Except for docker, all of the containers are cross-platform - x86 and ARM friendly! And are regularly maintained.

Once you've downloaded this git repo, be sure to check the corresponding docker-compose.yml file before executing pi-setup.sh. 
# You might want/need to change it, especially the environment parameters. 
Example:


```
$ cat wordpress-docker-compose.yml
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
git clone https://github.com/C-Fu/pi-setup.git
cd pi-setup
sudo chmod +x pi-setup.sh
sudo ./pi-setup.sh
```
