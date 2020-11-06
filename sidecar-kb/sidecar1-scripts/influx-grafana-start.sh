# We run this container with –rm key, this will only create configs and remove the container after.

mkdir -p /var/lib/docker/volumes/influxdb-volume/_data
mkdir -p /var/lib/docker/volumes/grafana-volume/_data

docker run --rm \
  -e INFLUXDB_DB=telegraf -e INFLUXDB_ADMIN_ENABLED=true \
  -e INFLUXDB_ADMIN_USER=admin \
  -e INFLUXDB_ADMIN_PASSWORD=supersecretpassword \
  -e INFLUXDB_USER=telegraf -e INFLUXDB_USER_PASSWORD=secretpassword \
  -v influxdb-volume:/var/lib/influxdb \
  influxdb /init-influxdb.sh

docker-compose up -d
