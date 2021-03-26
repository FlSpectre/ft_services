FROM alpine:latest

RUN apk update \
	&& apk upgrade

RUN apk add --update mysql mysql-client

COPY my.cnf /etc/mysql/my.cnf
COPY my.cnf /etc/my.cnf
COPY start.sh /
RUN mkdir -p /auth_pam_tool_dir/auth_pam_tool
RUN mkdir -p app

CMD sh /start.sh ;

EXPOSE 3306
