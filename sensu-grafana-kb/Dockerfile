FROM ubuntu:14.04

# Install the GPG public key
RUN wget -q http://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | sudo apt-key add -

# Create an APT configuration file at /etc/apt/sources.list.d/sensu.list
RUN echo "deb http://sensu.global.ssl.fastly.net/apt sensu main" | tee /etc/apt/sources.list.d/sensu.list

# Create an APT configuration file at /etc/apt/sources.list.d/sensu.list
RUN echo "deb http://sensu.global.ssl.fastly.net/apt sensu main" | tee /etc/apt/sources.list.d/sensu.list

# Install sensu
RUN apt-get install sensu

# Copy client.json
COPY client.json /etc/sensu/conf.d/client.json

# Copy transport.json
COPY transport.json /etc/sensu/conf.d/transport.json

# Copy api.json
COPY api.json /etc/sensu/conf.d/api.json

# Install Redis
RUN apt-get -y install redis-server

# Copy redis.json
COPY redis.json /etc/sensu/conf.d/redis.json



EXPOSE 3000 8080

CMD ["tail -f /dev/null"]
