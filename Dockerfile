FROM php:7.1.27-fpm

RUN apt-get update \
  && apt-get install -y \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libpng-dev \
    libxslt1-dev \
    git \
    vim \
    wget \
    lynx \
    psmisc \
    bzip2 \
    cron \
    supervisor \
  && apt-get clean

RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
  docker-php-ext-install \
    gd \
    intl \
    mbstring \
    mcrypt \
    pdo_mysql \
    xsl \
    zip \
    opcache \
    soap \
    bcmath


###############################################################################
#                                 Composer
###############################################################################

RUN curl -sS https://getcomposer.org/installer | \
    php -- \
      --install-dir=/usr/local/bin \
      --filename=composer \
      --version=1.7.3


###############################################################################
#                                 Node.js
###############################################################################
RUN curl -sL  https://deb.nodesource.com/setup_10.x | bash - && \
  apt-get install -y nodejs


###############################################################################
#                              MageRun for M2
###############################################################################
RUN cd /usr/local/bin && \
     wget https://files.magerun.net/n98-magerun2.phar --quiet && \
     chmod +x ./n98-magerun2.phar


###############################################################################
#                                Imagemagic
###############################################################################
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     libmagickwand-dev \
  && rm -rf /var/lib/apt/lists/*

RUN pecl install imagick-3.4.3 \
  && docker-php-ext-enable imagick


###############################################################################
#                               PHP-REDIS
###############################################################################

ENV PHPREDIS_VERSION 4.2.0

ADD https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz /tmp/redis.tar.gz
RUN tar xzf /tmp/redis.tar.gz -C /tmp \
    && mkdir -p /usr/src/php/ext \
    && mv /tmp/phpredis-$PHPREDIS_VERSION /usr/src/php/ext/redis \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis \
    && rm -rf /usr/src/php/ext/redis

###############################################################################
#                               PHP-REDIS
###############################################################################

RUN  apt-get clean && rm -rf /var/lib/apt/lists/*