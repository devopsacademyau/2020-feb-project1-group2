#Wordpress docker image with Php 7.4 and Apache
FROM wordpress:php7.4-apache
LABEL Maintainer = "Marcio Faria <marciodefaria@gmail.com>" \
      Description = "LAP stack to run WordPress."

# wp_data volume
VOLUME /var/www/html
WORKDIR /var/www/html

#ENV WORDPRESS_DB_USER RDS username
#ENV WORDPRESS_DB_PASSWORD RDS password
#ENV WORDPRESS_DB_HOST xx.x.x.x:3306 --RDS IP

# Ports
EXPOSE 80
EXPOSE 443
