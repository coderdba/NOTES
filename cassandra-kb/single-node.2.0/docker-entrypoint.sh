#!/bin/bash

exec > /tmp/docker-entrypoint.sh.out 2>> /tmp/docker-entrypoint.sh.out

/etc/init.d/cassandra stop

ps -ef|grep cas 

if [ -d /var/lib/cassandra/data_orig ]
then

echo 
echo INFO - Host volume already being used for data directory
echo

else

echo
echo WARN - Host volume is not being used for data directory - setting up now
echo

mv /var/lib/cassandra/data/* /var/lib/cassandra/data_host
mv /var/lib/cassandra/data /var/lib/cassandra/data_orig
ln -s /var/lib/cassandra/data_host /var/lib/cassandra/data

chown cassandra:cassandra /var/lib/cassandra/host_data /var/lib/cassandra/data

fi

/etc/init.d/cassandra start

exec "$@";
