influxd -config /etc/influxdb.conf
cat << EOF > admin.sql
CREATE DATABASE mydb;
USE mydb
EOF
# influx -precision rfc3339