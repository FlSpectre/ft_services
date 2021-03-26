FROM alpine:3.11.3

RUN apk -f upgrade && apk -f update
RUN apk -f add wget tar

RUN mkdir -p /etc/telegraf
RUN wget https://dl.influxdata.com/telegraf/releases/telegraf-1.15.2_linux_amd64.tar.gz \
&& tar -zxf telegraf-1.15.2_linux_amd64.tar.gz \
&& mv telegraf-1.15.2 telegraf \
&& rm telegraf-1.15.2_linux_amd64.tar.gz

RUN cp -rf telegraf/etc/* /etc/
RUN cp -rf telegraf/usr/* /usr/

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

RUN touch /var/run/utmp
COPY telegraf.conf /etc/telegraf/.

EXPOSE 35000

COPY start.sh .
CMD sh start.sh