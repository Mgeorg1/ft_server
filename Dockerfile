# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: aemustaf <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2020/12/26 16:16:24 by aemustaf          #+#    #+#              #
#    Updated: 2020/12/30 18:07:32 by aemustaf         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

FROM	debian:buster
RUN		apt-get update
RUN		apt-get upgrade -y
RUN		apt-get -y install wget 
RUN		apt-get -y install nginx
RUN		apt-get -y install mariadb-server
RUN		apt-get -y install php7.3 php-mysql php-fpm php-pdo php-gd php-cli php-mbstring
RUN		apt-get -y install vim
RUN		wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN		tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN		mv phpMyAdmin-5.0.1-english /var/www/phpmyadmin
COPY	./srcs/config.inc.php /var/www/phpmyadmin
RUN		wget https://wordpress.org/latest.tar.gz
RUN		tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
RUN		mv wordpress /var/www/
COPY 	./srcs/wp-config.php /var/www/wordpress
COPY	./srcs/nginx.conf /etc/nginx/sites-available/
RUN     ln -s /etc/nginx/sites-available/nginx.conf /etc/nginx/sites-enabled/
#RUN	rm -rf /etc/nginx/sites-enabled/default
RUN 	openssl req -x509 -nodes -days 365 -subj "/C=RU/ST=Tatarstan/L=Kazan/O=ecole42/OU=21Kazan/CN=aemustaf" \
		-newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;

RUN 	chown -R www-data:www-data /var/www/
RUN 	chmod -R 755 /var/www/*
COPY 	./srcs/init.sh ./
CMD 	bash init.sh