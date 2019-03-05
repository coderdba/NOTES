# Ingest URL Option (my own dumb sentence) used here

curl -O -k  https://dl.influxdata.com/telegraf/releases/telegraf-1.9.5-1.x86_64.rpm
rpm -Uvhtelegraf-1.9.5-1.x86_64.rpm

mkdir /etc/telegraf/telegraf.d

echo "
[tags] 
_blossom_id = \"CI05518558\"

[outputs.influxdb]
database = \"metrics\"
skip_database_creation = true
urls = [\"https://ingestURL.prod.company.com\"] "

systemctl enable telegraf
systemctl start telegraf
