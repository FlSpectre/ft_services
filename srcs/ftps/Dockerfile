FROM alpine:3.11.3

RUN apk update
RUN apk -f add openrc
RUN apk -f add openssl
RUN apk add bash pure-ftpd --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted --no-cache


RUN adduser admin --disabled-password && echo "admin:admin" | chpasswd
RUN chown admin /home/admin
RUN mkdir -p /etc/ssl/private

RUN yes "" | openssl req -x509 -nodes -days 720 -newkey rsa:2048 -keyout /etc/ssl/private/pure-ftpd.pem -out /etc/ssl/private/pure-ftpd.pem

COPY start.sh /

EXPOSE 21 20 30020-30023

CMD sh start.sh