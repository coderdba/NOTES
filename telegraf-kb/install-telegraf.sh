# Ingest URL Option (my own dumb sentence) used here

echo
echo downloading Telegraf
echo
curl -O -k https://dl.influxdata.com/telegraf/releases/telegraf-1.9.5-1.x86_64.rpm

echo
echo installing
echo
rpm -Uvh ./telegraf-1.9.5-1.x86_64.rpm

echo
echo creating config file
echo
confdir=/etc/telegraf/telegraf.d
mkdir -p $confdir

echo "
[tags] 
_blossom_id = \"CI05518558\"

[outputs.influxdb]
database = \"metrics\"
skip_database_creation = true
urls = [\"https://ingestUrl.prod.company.com\"] " > ${confdir}/default_outputs.conf

echo
echo service start
echo
systemctl enable telegraf
systemctl start telegraf

echo 
echo STATUS OF SERVICE
echo
systemctl status telegraf


echo
echo NETSTAT
echo
sleep 10
netstat -anp |grep telegraf

echo 
echo done
