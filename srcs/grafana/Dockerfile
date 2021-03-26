FROM alpine:3.11.3

RUN apk update
# RUN apk add --no-cache grafana --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community
RUN wget https://dl.grafana.com/oss/release/grafana-6.7.2.linux-amd64.tar.gz \
&& tar -zxvf grafana-6.7.2.linux-amd64.tar.gz
RUN mv grafana-6.7.2 grafana
RUN apk add --no-cache libc6-compat

# RUN rm /usr/share/grafana/conf/sample.ini
COPY grafana.db grafana/data/
COPY start.sh start.sh
# COPY sample.ini usr/share/grafana/conf/

EXPOSE 3000

CMD sh start.sh