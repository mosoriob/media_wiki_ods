FROM php:7.3.31-apache
RUN a2enmod rewrite

RUN apt-get update && apt-get install -y zip unzip git vim imagemagick \
    libfreetype6-dev libjpeg62-turbo-dev libpng-dev libzip-dev zlib1g-dev exiftool \
    libicu-dev

RUN docker-php-ext-configure intl && docker-php-ext-install intl \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/  \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install mysqli mbstring opcache exif pdo_mysql \
    && docker-php-ext-configure opcache --enable-opcache

ADD custom_wiki.tar.gz /var/www/html/
COPY LocalSettings.php /var/www/html/
WORKDIR /var/www/html/
# Maybe this should be a volume
RUN chmod -R 777 images/

COPY 000-default.conf /etc/apache2/sites-available/
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini \
    && sed -e 's/max_execution_time = 30/max_execution_time = 300/' -i  /usr/local/etc/php/php.ini