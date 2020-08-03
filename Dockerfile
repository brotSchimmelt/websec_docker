# This is the default value for the php version
# If $php_version is set, the default is overridden
ARG php_version=7.3-apache
FROM php:$php_version

ENV APACHE_DOCUMENT_ROOT=/var/www/html/shop/public
ENV TIMEZONE="Europe/Berlin"

RUN ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone

# Set the new document root
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Use the php.ini-development
RUN mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini
RUN sed -i 's!;date.timezone =!date.timezone = ${TIMEZONE}!g' /usr/local/etc/php/php.ini

# Make sure all neccessary php packages are installed
RUN docker-php-ext-install pdo pdo_mysql mbstring
# pdo & pdo_mysql: for the DB connection
# mbstring: for multibyte character encoding schemes for strings
