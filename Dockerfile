FROM php:7.2.12-fpm

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      bzip2 \
      cron \
      git \
      gnupg \
      libfreetype6-dev \
      libicu-dev \
      libjpeg62-turbo-dev \
      libmcrypt-dev \
      libpng-dev \
      libxslt1-dev \
      lynx \
      psmisc \
      vim \
      wget \
      supervisor

RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
    docker-php-ext-install \
      bcmath \
      gd \
      intl \
      mbstring \
      opcache \
      pdo_mysql \
      soap \
      xsl \
      zip \
      pcntl

###############################################################################
#                               PHP-REDIS
###############################################################################
RUN pecl install redis && docker-php-ext-enable redis

###############################################################################
#                               PHP-mcrypt
###############################################################################
RUN pecl install mcrypt-1.0.1 && docker-php-ext-enable mcrypt

###############################################################################
#                                Imagemagic
###############################################################################
RUN apt-get install -y --no-install-recommends \
    libmagickwand-dev

RUN pecl install imagick-3.4.3 && \
    docker-php-ext-enable imagick

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
#                              Clean Up
###############################################################################
RUN  apt-get clean && rm -rf /var/lib/apt/lists/*
