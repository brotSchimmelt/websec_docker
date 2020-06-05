ARG php_version=7.3-apache
FROM php:$php_version

ENV APACHE_DOCUMENT_ROOT=/var/www/html/shop/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN mv /usr/local/etc/php/php.ini-development /usr/local/etc/php/php.ini

RUN docker-php-ext-install mysqli pdo pdo_mysql mbstring