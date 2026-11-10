
FROM php:8.3-fpm

WORKDIR /var/www

# Dependências do sistema
RUN apt-get update && apt-get install -y \
    git curl unzip zip \
    libpng-dev libjpeg62-turbo-dev \
    libfreetype6-dev libonig-dev \
    libxml2-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    pdo_mysql mbstring exif pcntl bcmath gd zip opcache \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copia aplicação
COPY . .

# Instala dependências
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Permissões
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 9000

CMD ["php-fpm"]
