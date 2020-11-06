mkdir /etc/telegraf
docker run --rm telegraf telegraf config | sudo tee /etc/telegraf/telegraf.conf &lt > /dev/null
