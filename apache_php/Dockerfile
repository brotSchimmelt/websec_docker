## This Dockerfile provides an Apache Webserver with PHP

# This is the default value for the php version
ARG php_version=7.3-apache
# If $php_version is set in the docker-compose file, the default is overridden
FROM php:$php_version

# Variables
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
ENV TIMEZONE="Europe/Berlin"
# proxy server for the wwu network
# ENV http_proxy http://wwwproxy.uni-muenster.de:3128
# ENV https_proxy http://wwwproxy.uni-muenster.de:3128

# Set the new document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install mSMTP
RUN apt-get update && apt-get install msmtp -y
# Copy the mSMTP config file
COPY msmtprc /etc/msmtprc
RUN chmod 600 /etc/msmtprc
RUN chown www-data:www-data /etc/msmtprc
RUN mkdir /var/log/msmtp
RUN chown www-data:www-data /var/log/msmtp/

# Use the php.ini-development
RUN mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

# Set mSMTP as the default MTA in the php.ini
RUN sed -i 's!;sendmail_path =!sendmail_path = /usr/bin/msmtp -t!g' /usr/local/etc/php/php.ini

# Set the PHP timezone in the php.ini
RUN sed -i 's!;date.timezone =!date.timezone = ${TIMEZONE}!g' /usr/local/etc/php/php.ini
# Set the sytem timezone
RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# Make sure the PHP session cookie can not be accidently changed by JavaScript in the XSS challenge
RUN sed -i 's!session.cookie_httponly =!session.cookie_httponly =1!g' /usr/local/etc/php/php.ini

# Make sure all neccessary php packages are installed
## pdo & pdo_mysql: for the DB connection
## mbstring: for multibyte character encoding schemes for strings
RUN docker-php-ext-install pdo pdo_mysql mbstring
