FROM alpine:latest

RUN apk update \
	&& apk upgrade \
	&& apk add nginx \
	&& apk add openssl openssh

RUN rm /etc/nginx/conf.d/default.conf
ADD default.conf /etc/nginx/conf.d/default.conf
RUN mkdir /run/nginx
RUN mkdir -p /usr/share/nginx/html
ADD index.html /usr/share/nginx/html/index.html
RUN chmod 666 /usr/share/nginx/html/index.html
RUN yes "" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx-selfsigned.key -out /etc/ssl/certs/nginx-selfsigned.crt
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -t rsa -N ''

COPY pass.sh /tmp/pass.sh
COPY start.sh /start.sh
RUN sh /tmp/pass.sh

EXPOSE 80 443

CMD sh /start.sh ;