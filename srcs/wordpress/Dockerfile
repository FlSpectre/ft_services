FROM alpine:latest

RUN apk update \
	&& apk upgrade
RUN apk add --no-cache php7\
	php7-fpm php7-opcache \
	php7-gd php7-mysqli php7-zlib php7-curl \
	php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-ctype
RUN apk -f add nginx wget
RUN apk -f add mysql-client mysql-server

RUN rm /etc/nginx/conf.d/default.conf
ADD default.conf /etc/nginx/conf.d/default.conf
COPY ./wordpress.sql /
COPY wordpress /etc/nginx/site/
COPY index.html /etc/nginx/site/
RUN chmod 777 wordpress.sql
COPY wp-config.php /etc/nginx/site/
RUN chmod -R 777 /etc/nginx/site 
COPY setup.sh /

EXPOSE 5050

CMD sh /setup.sh