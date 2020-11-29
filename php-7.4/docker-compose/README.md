# instructions
This docker-compose.yml provides a base setup for a working TSI environment. It comes with a webserver, database, redis cache, PhpMyAdmin and Teamspeak3 server. This is made to test the webinterface or if you want to setup a teamspeak environment with TSI for a lan party or something like that. ***It is not meant to be run as productive environment!***

## requirements
- You need to have a working docker environment installed. See https://docs.docker.com/engine/ for details.
- A copy of the 'docker-compose' folder including all files and folders in it! Easiest way is to download the whole project from https://github.com/MyUncleSam/docker-tsi/releases/latest
- A (t)eamspeak server (not provided in this package!)

## run
### first run
1. Edit docker-compose.yml based on you needs. See the 'settings' region for more information.
2. Download TSI from https://dwwe.de and extract it into the subfolder 'html'
3. On windows run the 'start_firstrun.bat' and on linux the 'start_firstrun.sh' file.
4. Now it starts to download all needed components, set them up and starts all services. This takes some time based on your internet connection and the power of your machine.
5. The teamspeak3 server creates two importent information on start. The serveradmin password and a token which can be used to make you sa. Just scroll up and you see them. ***(Do not access the webinterface till you noted these information! You can access the token by checking the teamspeak3 logs inside 'ts3/logs' - but the serveadmin password is not logged into these files!)***
6. As the firstrun start scripts are only needed to get the teamspeak information we now stop it again by pressing CTRL+C. This should now stop all running processes. (On windows there is a dialog at the end, simply close the windows or choose yes or no - it does not matter what you choose.)
7. Start it again the normal way by running 'start.bat' for windows and 'start.sh' for linux.
8. Open your browser and go to http://localhost (it could take some seconds till the webpage is up)
9. Follow the setup process. The default database credentials can be found in the 'default configuration' area below.
10. The webinterface should now be ready.
11. Please read how to stop below to avoid damaging to the database!

After all is done I recommand to enable redis caching. Go to Settings->System and scroll down till 'cache driver configuration'. See the redis cache information under the default configuration (below).

### start again
Simply call the 'start.bat' (windows) or 'start.sh' (linux). Based on the information in the folders everything should be back as you left it. Please read how to stop below to avoid damage to the database!

### stop
On windows run the 'stop.bat' and on linux the 'stop.sh' file. All in all docker should stop everything fine if you simply shutdown your pc.

# known issues
## slow
If you run it directly inside of windows it is very very slow. This is not the fault of TSI. It has something to do with how docker needs to workaround windows to be able to run containers inside windows. If you run these containers directly in linux they are fast as usual. So only consider using it with windows for testing purposes!

No idea why but it is much faster if you directly start it on the WSL. Please only try this if you know linux and bash as it is to complex to describe every step here. So only the importent steps are listed:
1. Open the bash
2. Clone the repository
3. Place the TSI files inside the html folder (port 22 is reserved by windows, if you want to use ssh/scp you need to change the ssh port)
4. Follow the instructions. All ports are redirected to the local machine, but now it is much faster.

## github
First of all take a look into the github issue list of the TSI docker image: https://github.com/MyUncleSam/docker-tsi/issues
If you have troubles not mentioned here, feel free to create a issue on github.

# default configuration
## database
| name | value |
| ---- | ----- |
| db host | tsi-db |
| db user | tsi |
| db password | tsi2020 |
| db name | tsi |
| mysql root password (for PhpMyAdmin) | root2020 |

## redis cache
| name | value |
| ---- | ----- |
| Host / IP | tsi-redis |
| Port | 6379 |
| Database / Bucket | 1 |

## teamspeak3 server
| name | value |
| ---- | ----- |
| host / server ip | tsi-ts3 |

## ports
| name | port | url |
| ---- | ---- | ----- |
| TSI | 80 | http://localhost |
| PhpMyAdmin | 8081 | http://localhost:8081 |
| Teamspeak3 | *default ports* | |

# settings
You can find all settings inside the docker-compose.yml file. You do not have to but it is highly suggested to edit this information:

## environment parameters
Change database usernames and passwords by editing all environment variables inside the tsi-db container.

## port
By default tsi is avaible on port 80 and phpmyadmin on 8081. To change that see the port mapping inside the tsi and tsi-pma container. (only change the first number and not the second one! e.g. 80:80 --> 8123:80 makes it available on port 8123.)

# volumes / persistent data
## database
The mariadb container saves all information in the subfolder 'db'.

# backup
As this is not meant to be used inside productive environments there is no backup functionality included. But you can stop all container and backup the complete folder structure as it contains all files used by the services.

# update
As this is not meant to be used inside productive environment there is no update functionality included. Not sure but maybe it updates itselfe on every start.

# use your own teamspeak3 server
Just remove the complete 'tsi-ts3' part from the docker-compose.yml file. Also remove all references with the 'tsi-ts3' name. This avoids the system to start the teamspeak 3 server. If you do so, you can skip the part 4-7 from the first run documentation.

There is just one thing:
Your teamspeak 3 have to run on another machine than the docker host. It is just because docker containers cannot access ports from their host.

# images used
Here is a list of all used images. If you want or need to change some things, feel free to take a look at their documentation.

| name | url |
| ---- | --- |
| tsi-db | https://hub.docker.com/_/mariadb |
| tsi | https://hub.docker.com/repository/docker/stefanruepp/docker-tsi |
| tsi-pma | https://hub.docker.com/r/phpmyadmin/phpmyadmin |
| tsi-redis | https://hub.docker.com/_/redis |
| tsi-ts3 | https://hub.docker.com/_/teamspeak |