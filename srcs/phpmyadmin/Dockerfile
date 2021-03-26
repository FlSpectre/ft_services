FROM alpine:latest


RUN apk update \
	&& apk upgrade \
	&& apk add nginx \
	&& apk add openssl openssh

RUN apk add php7 php7-fpm php7-opcache php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json php7-session

RUN rm /etc/nginx/conf.d/default.conf
ADD default.conf /etc/nginx/conf.d/default.conf
RUN mkdir /run/nginx
RUN yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''

RUN wget http://files.directadmin.com/services/all/phpMyAdmin/phpMyAdmin-5.0.2-all-languages.tar.gz \
	&& tar zxvf phpMyAdmin-5.0.2-all-languages.tar.gz \
	&& rm phpMyAdmin-5.0.2-all-languages.tar.gz \
	&& mv phpMyAdmin-5.0.2-all-languages /usr/share/phpmyadmin \
	&& rm -rf /var/cache/apk/*


COPY config.inc.php /usr/share/phpmyadmin/config.inc.php

COPY ./start.sh /start.sh

EXPOSE 5000

CMD sh ./start.sh