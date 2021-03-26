FROM alpine:3.11.3
RUN apk -f upgrade && apk -f update
RUN apk -f add wget
RUN apk add influxdb --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/community

COPY ./start.sh .
COPY ./database.influx .
COPY influxdb.conf /etc/influxdb/.
RUN mkdir -p app/influxdb

RUN mkdir /opt/collectd && mkdir /opt/collectd/share && mkdir /opt/collectd/share/collectd && cd /opt/collectd/share/collectd && wget https://raw.githubusercontent.com/collectd/collectd/master/src/types.db && cd -

EXPOSE 8086

CMD sh start.sh