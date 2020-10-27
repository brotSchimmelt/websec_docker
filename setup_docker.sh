#!/bin/bash

################################################################################
#   Purpose: Set up the docker enviroment for the hacking platform             #
#   Test: Tested on Ubuntu 18 LTS                                              #
#   Note: Not yet tested on Ubuntu 20 LTS                                      #
#   Author: tknebler@gmail.com                                                 #
#                                                                              #
#   Run script with 'sudo'                                                     #
#   Backup any old configuration files                                         #    
#   Remove source control configurations and test files                        #
#   Set up MySQL user, password and root password                              #
#   Set up mail account password                                               #
#   Set up phpMyAdmin installation                                             #
#   Create new '.env' file                                                     #
#   Set up the server URI                                                      #
#   Write new settings to php configuration files                              #
#   Check (and if necessary install) docker and docker-compose                 #
#   Set permissions for apache user (www-data)                                 #
#   Set up Uni Muenster proxy                                                  #
#   Build the custom apache docker image with new configurations               #
################################################################################

# default values for the env variables
php_version="7.4-apache"
mysql_version="8.0"
timezone="Europe/Berlin"
proxy="http://wwwproxy.uni-muenster.de:3128"

# font colors
red="\031[0;32m"
orange="\033[0;33m"
green="\033[0;32m"
noColor="\033[0m"

# run script with 'sudo'  
if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$@"
fi

printf "\nThis script will set up the .env file for docker-compose and build "\
"the container images.\n\n"

printf "Continue? [Y/n] "
read answer

if [ -z $answer ]; then
answer='Y'
fi

if [ $answer == 'n' ] || [ $answer == 'N' ]; then
printf "\n${green}OK, nothing has been changed!${noColor}\n\n"
exit 0
fi

printf "\n\n${orange}##### NOTE #####${noColor}\n"
printf "${orange}For the two DBs ('shop' & 'login') we will configure the "\
"same user and password.${noColor}\n"
printf "${orange}If you wish to change those, you can manually change them "\
"in the .env file after this script is done.${noColor}\n\n\n"

# backup any old configuration files 
printf "Backing up any old configuration files ..."
mv .env env.backup 2> /dev/null
mv example.env env.example 2> /dev/null
rm *.env 2> /dev/null
printf "\n${green}done${noColor}\n\n"

# remove source control configurations
printf "Removing any source control configurations ..."
rm -r .git 2> /dev/null
rm .gitignore 2> /dev/null
rm -r ./apache_php/www/.git 2> /dev/null
rm ./apache_php/www/.gitignore 2> /dev/null
printf "\n${green}done${noColor}\n\n"

# remove test files  
printf "Removing test files ..."
rm -r ./apache_php/www/tests 2> /dev/null
rm -r ./apache_php/www/vendor 2> /dev/null
rm ./apache_php/www/composer.lock 2> /dev/null
rm ./apache_php/www/composer.json 2> /dev/null
rm ./apache_php/www/phpunit.xml 2> /dev/null
printf "\n${green}done${noColor}\n\n"

# set up MySQL user
printf "Enter a username for the MySQL DBs: "
read user

# add MySQL user password
done_pwd=false
while ( ! $done_pwd ); do

    printf "\nEnter password for $user: "
    read -s pwd

    printf "\nConfirm the password: "
    read -s confirm_pwd

    if [ $pwd == $confirm_pwd ]; then
        done_pwd=true
    else
        printf "\n\nThe password does not match. Please try again!"
    fi
done

# add MySQL root password
done_root=false
while ( ! $done_root ); do

    printf "\n\nOK, now choose a root password: "
    read -s root_pwd

    printf "\nConfirm root password: "
    read -s confirm_root_pwd

    if [ $root_pwd == $confirm_root_pwd ]; then
        done_root=true
    else
        printf "\n\nThe password does not match. Please try again!"
    fi
done

# set up smtp client
printf "Enter the password for the WebSec mail account: "
read -s mail_pwd

# set up phpMyAdmin installation
printf "\n\nYou have 2 options to install phpMyAdmin:\nYou can either install 
it in an extra container or integrate it in the apache container. By 
integrating it, you do not need an open port to access it. (But it is still 
${orange}recommended${noColor} to install it separatley though.)\nSo, do you 
want to use phpMyAdmin in an extra container (open port available)? [Y/n]"
read answer

if [ -z $answer ]; then
    answer='Y'
fi

if [ $answer == 'n' ] || [ $answer == 'N' ]; then
    printf "\nChanging docker-compose settings to use apache container ..."
    cp docker-compose.yml docker-compose_php.backup
    cp docker-compose_pma.yml docker-compose_pma.backup
    mv docker-compose.yml docker-compose_php.yml
    mv docker-compose_pma.yml docker-compose.yml
    sleep 2 # wait to ensure the file operations are done

    printf "\nChanging links to phpMyAdmin ..."
    sed -i "s!':8082'!/pma/!g" ./apache_php/www/src/includes/admin_sidebar.php
    
    printf "\nphpMyAdmin will now start in the same container as apache!"
    printf "\n${green}done${noColor}"
else
    printf "\nOK, on what port do you want phpMyAdmin to listen? "
    read answerPort

    sed -i "s!'8082'!$answerPort!g" ./apache_php/www/src/includes/admin_sidebar.php
    sed -i "s!'8082'!$answerPort!g" ./docker-compose.yml
    printf "\nOK, phpMyAdmin listens now on port ${orange} $answerPort ${noColor}"
    printf "\n${green}done${noColor}"
fi

printf "\n\nWriting .env file ..."

# create new '.env' file
env_content="VERSION_PHP=$php_version
VERSION_MYSQL=$mysql_version

CONTAINER_NAME_PHP=php_apache
CONTAINER_NAME_PHP_PMA=php_apache_pma
CONTAINER_NAME_MYSQL_SHOP=db_shop
CONTAINER_NAME_MYSQL_LOGIN=db_login

MYSQL_DB_SHOP=shop
MYSQL_USER_SHOP=$user
MYSQL_PASSWORD_SHOP=$pwd
MYSQL_ROOT_PASSWORD_SHOP=$root_pwd

MYSQL_DB_LOGIN=login
MYSQL_USER_LOGIN=$user
MYSQL_PASSWORD_LOGIN=$pwd
MYSQL_ROOT_PASSWORD_LOGIN=$root_pwd

TIMEZONE=$timezone

MAIL_PWD=$mail_pwd"

echo "$env_content" > .env
sleep 2 # wait to ensure the file operations are done
printf "\n${green}done${noColor}\n\n"

# set up the server URI
done_uri=false
while ( ! $done_uri ); do

    printf "Under which URI should this site be accessible? "
    read uri

    printf "Is ${orange} $uri ${noColor} correct? [Y/n] "
    read answer

    if [ -z $answer ]; then
        answer='Y'
    fi

    if [ $answer == 'n' ] || [ $answer == 'N' ]; then
        done_uri=false
    else
        done_uri=true
    fi
done

# write new settings to php configuration files
printf "\nWriting to php config files ..."
cp ./apache_php/www/config/config.php ./apache_php/www/config/config.backup
cp ./apache_php/www/config/db_login.php ./apache_php/www/config/db_login.backup
cp ./apache_php/www/config/db_shop.php ./apache_php/www/config/db_shop.backup

sed -i "s!'SITE_URL', '.*'!'SITE_URL', '$uri'!g" ./apache_php/www/config/config.php

sed -i "s!// TODO: change credentials to real ones!!g" \
./apache_php/www/config/db_login.php
sed -i "s!// Dummy credentials from the docker example.env file!!g" \
./apache_php/www/config/db_login.php
sed -i "s!'DB_USER_LOGIN', '.*'!'DB_USER_LOGIN', '$user'!g" \
./apache_php/www/config/db_login.php
sed -i "s!'DB_PWD_LOGIN', '.*'!'DB_PWD_LOGIN', '$pwd'!g" \
./apache_php/www/config/db_login.php

sed -i "s!// TODO: change credentials to real ones!!g" \
./apache_php/www/config/db_shop.php
sed -i "s!// Dummy credentials from the docker example.env file!!g" \
./apache_php/www/config/db_shop.php
sed -i "s!'DB_USER_SHOP', '.*'!'DB_USER_SHOP', '$user'!g" \
./apache_php/www/config/db_shop.php
sed -i "s!'DB_PWD_SHOP', '.*'!'DB_PWD_SHOP', '$pwd'!g" \
./apache_php/www/config/db_shop.php

sleep 2 # wait to ensure the file operations are done
printf "\n${green}done${noColor}\n\n"

## Check (and if necessary install) docker and docker-compose 

# check if docker is installed
docker --version &> /dev/null

if [ $? -gt 0 ]; then
    printf "${red}It seems like 'docker' is not yet installed.${noColor}\n"
    printf "${red}Please go to https://docs.docker.com/get-docker/ and follow "\
    "the instructions to install the newest version of docker for "\
    "your operating system.${noColor}\n"
    exit 1
fi

# check if docker-compose is installed
docker-compose --version &> /dev/null

if [ $? -gt 0 ]; then
    printf "${red}It seems like 'docker-compose' is not yet "\
    "installed.${noColor}\n"
    printf "Would you like to install it now from the docker "\
    "github page? [Y/n] "
    read answer

    if [ -z $answer ]; then
        answer='Y'
    fi

    if [ $answer == 'y' ] || [ $answer == 'Y' ]; then

        printf "\n\nInstalling 'docker-compose' ...\n"

        sleep 2 # wait for curl
        curl -L \
        "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose

        chmod +x /usr/local/bin/docker-compose

        # add user to group docker
        gpasswd -a $USER docker
        newgrp docker

        sleep 2 # wait for grp operations
        printf "\n${green}done${noColor}\n\n"
    else
        printf "\n${orange}Without docker-compose you have to start the "\
        "container manually.${noColor}\n\n"
        exit 0
    fi
fi

# set permissions for apache user (www-data) 
printf "Setting permission for www-data ..."
chown www-data ./apache_php/www/data &> /dev/null
printf "\n${green}done${noColor}\n\n"

# set up Uni Muenster proxy
printf "Do you want to configure docker to use the Uni Muenster proxy? [y/N] "
read answer

if [ -z $answer ]; then
    answer='N'
fi

if [ $answer == 'y' ] || [ $answer == 'Y' ] || [ $answer == 'yes' ]; then
    printf "\nsetting ${orange} wwwproxy.uni-muenster.de:3128 ${noColor} as "
    printf "HTTP and HTTPS proxy ...\n\n"

    printf "creating a systemd drop-in directory for the docker service ..."
    mkdir -p /etc/systemd/system/docker.service.d
    sleep 1
    printf "\n${green}done${noColor}\n\n"

    printf "creating 'http-proxy.conf' ..."
    touch /etc/systemd/system/docker.service.d/http-proxy.conf
    sleep 1
    sh -c 'printf "[Service]\nEnvironment=first\nEnvironment=second\n"> \
    /etc/systemd/system/docker.service.d/http-proxy.conf'
    sed -i 's!first!"HTTP_PROXY=http://wwwproxy.uni-muenster.de:3128"!g' \
    /etc/systemd/system/docker.service.d/http-proxy.conf
    sed -i 's!second!"HTTPS_PROXY=http://wwwproxy.uni-muenster.de:3128"!g' \
    /etc/systemd/system/docker.service.d/http-proxy.conf
    printf "\n${green}done${noColor}\n\n"

    printf "changing 'Dockerfile' ..."
    sed -i 's!# ENV!ENV!g' ./apache_php/Dockerfile
    printf "\n${green}done${noColor}\n\n"

    printf "flushing changes and restart docker ..."
    systemctl daemon-reload
    sleep 5
    systemctl restart docker
    sleep 5
    printf "\n${green}done${noColor}\n\n"

else
    printf "\n${green}OK, proxy settings remain unchanged!${noColor}\n\n"
fi

printf "building images (get yourself a coffee) ... "
docker-compose build -q
printf "\n${green}done${noColor}\n\n"

printf "You can now start the server with ${green}docker-compose "\
"up -d${noColor}!\n\n"

printf "${orange}##### Attention #####${noColor}\n"
printf "${orange}Don't forget to change the default password for the "\
"${noColor}administrator${orange} user after the first login!${noColor}\n\n"
