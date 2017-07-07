echo >> /tmp/start_services.out 2>> /tmp/start_services.out
date >> /tmp/start_services.out 2>> /tmp/start_services.out
echo >> /tmp/start_services.out 2>> /tmp/start_services.out
service sensu-server start >> /tmp/start_services.out 2>> /tmp/start_services.out
service sensu-client start >> /tmp/start_services.out 2>> /tmp/start_services.out
service rabbitmq-server start >> /tmp/start_services.out 2>> /tmp/start_services.out
service redis-server start >> /tmp/start_services.out 2>> /tmp/start_services.out
service sensu-api start >> /tmp/start_services.out 2>> /tmp/start_services.out
service uchiwa start >> /tmp/start_services.out 2>> /tmp/start_services.out
service carbon-cache start >> /tmp/start_services.out 2>> /tmp/start_services.out
service apache2 start >> /tmp/start_services.out 2>> /tmp/start_services.out
