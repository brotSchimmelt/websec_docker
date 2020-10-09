#!/bin/bash

# check if the script is run with 'sudo'
if [[ $EUID -ne 0 ]];
then
    exec sudo /bin/bash "$0" "$@"
fi

# default values
php_version="7.3-apache"
mysql_version="5.7.30"
timezone="Europe/Berlin"
proxy="http://wwwproxy.uni-muenster.de:3128"

# colors
red="\031[0;32m"
orange="\033[0;33m"
green="\033[0;32m"
noColor="\033[0m"

printf "\nThis script will set up the .env file for docker and build the container images.\n\n"

printf "Continue? [Y/n] "
read answer

if [ -z $answer ]; then
answer='Y'
fi

if [ $answer == 'n' ] || [ $answer == 'N' ]; then
printf "\nOK, bye!\n\n"
exit 0
fi

printf "\n\n##### NOTE #####\n"
printf "For the two DBs ('shop' & 'login') we will configure the same user and password.\n"
printf "If you wish to change those, you can manually change them in the .env file.\n\n\n"

printf "Removing any old configuration files ...\n\n"
# make backup files
mv .env env.backup 2> /dev/null
mv example.env env.example 2> /dev/null
rm *.env 2> /dev/null

printf "Removing any source control configurations ...\n\n"
rm -r .git 2> /dev/null
rm .gitignore 2> /dev/null
rm -r ./www/.git 2> /dev/null
rm ./www/.gitignore 2> /dev/null

printf "Removing test files ...\n\n"
rm -r ./www/tests 2> /dev/null
rm -r ./www/vendor 2> /dev/null
rm ./www/composer.lock 2> /dev/null
rm ./www/composer.json 2> /dev/null
rm ./www/phpunit.xml 2> /dev/null

printf "Enter a username for the MySQL DBs: "
read user

done_pwd=false
while ( ! $done_pwd )
do

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

done_root=false
while ( ! $done_root )
do

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

printf "\n\nWriting .env file ...\n\n"

# content of the configuration file
env_content="VERSION_PHP=$php_version
VERSION_MYSQL=$mysql_version

CONTAINER_NAME_PHP=php_apache
CONTAINER_NAME_MYSQL_SHOP=db_shop
CONTAINER_NAME_MYSQL_LOGIN=db_login
CONTAINER_NAME_PMA_SHOP=phpmyadmin_shop
CONTAINER_NAME_PMA_LOGIN=phpmyadmin_login

MYSQL_DB_SHOP=shop
MYSQL_USER_SHOP=$user
MYSQL_PASSWORD_SHOP=$pwd
MYSQL_ROOT_PASSWORD_SHOP=$root_pwd

MYSQL_DB_LOGIN=login
MYSQL_USER_LOGIN=$user
MYSQL_PASSWORD_LOGIN=$pwd
MYSQL_ROOT_PASSWORD_LOGIN=$root_pwd

TIMEZONE=$timezone"

echo "$env_content" >> .env
sleep 2

printf "Writing to php config files ...\n\n"
cp ./www/config/db_login.php ./www/config/db_login.backup
cp ./www/config/db_shop.php ./www/config/db_shop.backup

sed -i "s!// TODO: change credentials to real ones!!g" ./www/config/db_login.php
sed -i "s!// Dummy credentials from the docker example.env file!!g" ./www/config/db_login.php
sed -i "s!'DB_USER_LOGIN', '.*'!'DB_USER_LOGIN', '$user'!g" ./www/config/db_login.php
sed -i "s!'DB_PWD_LOGIN', '.*'!'DB_PWD_LOGIN', '$pwd'!g" ./www/config/db_login.php

sed -i "s!// TODO: change credentials to real ones!!g" ./www/config/db_shop.php
sed -i "s!// Dummy credentials from the docker example.env file!!g" ./www/config/db_shop.php
sed -i "s!'DB_USER_SHOP', '.*'!'DB_USER_SHOP', '$user'!g" ./www/config/db_shop.php
sed -i "s!'DB_PWD_SHOP', '.*'!'DB_PWD_SHOP', '$pwd'!g" ./www/config/db_shop.php

sleep 2

# check if docker is installed
docker --version &> /dev/null

if [ $? -gt 0 ]; then
printf "It seems like 'docker' is not yet installed.\n"
printf "Please go to https://docs.docker.com/get-docker/ and follow the instructions to install 
the newest version of docker for your operating system.\n"
exit 1
fi

# check if docker-compose is installed
docker-compose --version &> /dev/null

if [ $? -gt 0 ]; then
printf "It seems like 'docker-compose' is not yet installed.\n"
printf "Would you like to install it now from the docker github page? [Y/n] "
read answer

    if [ -z $answer ]; then
    answer='Y'
    fi

    if [ $answer == 'y' ] || [ $answer == 'Y' ]; then
    printf "\n\nInstalling 'docker-compose' ...\n"
    sleep 2
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    # add user to group docker
    sudo gpasswd -a $USER docker
    newgrp docker

    sleep 2
    printf "\n\n"
    else
    printf "\nOK, bye!\n\n"
    exit 0
    fi
fi

printf "setting permission for www-data ...\n\n"
sudo chown www-data ./www/data &> /dev/null

printf "Do you want to configure docker to use the uni muenster proxy? [y/N] "
read answer

if [ -z $answer ]; then
answer='N'
fi

if [ $answer == 'y' ] || [ $answer == 'Y' ] || [ $answer == 'yes' ]; then
printf "\nsetting ${orange}wwwproxy.uni-muenster.de:3128${noColor} as HTTP and HTTPS proxy ...\n\n"

sleep 1

printf "creating a systemd drop-in directory for the docker service ...\n\n"
mkdir -p /etc/systemd/system/docker.service.d

printf "creating 'http-proxy.conf' ...\n\n"
touch /etc/systemd/system/docker.service.d/http-proxy.conf
sh -c 'printf "[Service]\nEnvironment=first\nEnvironment=second\n"> /etc/systemd/system/docker.service.d/http-proxy.conf'
sed -i 's!first!"HTTP_PROXY=http://wwwproxy.uni-muenster.de:3128"!g' /etc/systemd/system/docker.service.d/http-proxy.conf
sed -i 's!second!"HTTPS_PROXY=http://wwwproxy.uni-muenster.de:3128"!g' /etc/systemd/system/docker.service.d/http-proxy.conf

printf "changing 'Dockerfile' ...\n\n"
sed -i 's!# ENV http_proxy http://wwwproxy.uni-muenster.de:3128!ENV http_proxy http://wwwproxy.uni-muenster.de:3128!g' ./apache_php/Dockerfile
sed -i 's!# ENV https_proxy http://wwwproxy.uni-muenster.de:3128!ENV https_proxy http://wwwproxy.uni-muenster.de:3128!g' ./apache_php/Dockerfile

printf "flushing changes and restart docker ...\n\n"
systemctl daemon-reload
sleep 5
systemctl restart docker
sleep 5

else
printf "\n${green}OK, proxy settings remain unchanged!${noColor}\n\n"
fi

printf "building images (this might take up to 5 mins) ...\n\n"
docker-compose build -q

printf "\n\nYou can now start the server with ${green}docker-compose up -d${noColor}\n"

printf "${orange}Don't forget to change the default password for the administrator user after first login!${noColor}\n\n"
