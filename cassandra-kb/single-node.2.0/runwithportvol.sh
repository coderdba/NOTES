# v 2.0 image
# mount /u01/mywork/cassandra/volumes/cassandraonex2/data on host to container /var/lib/cassandra/data_host
docker run --privileged --name cassandraonex2 -v /sys/fs/cgroup:/sys/fs/cgroup:ro  -v /u01/mywork/cassandra/volumes/cassandraonex2/data:/var/lib/cassandra/data_host:rw -p 127.0.0.1:9042:9042 -p 127.0.0.1:9160:9160 -it -d 3aad9985ad40 tail -f /dev/null
#docker run --privileged --name cassandraonex2 -v /sys/fs/cgroup:/sys/fs/cgroup:ro  -v /u01/mywork/cassandra/volumes/cassandraonex2/data:/var/lib/cassandra/data_host:rw -p 10.63.160.170:9042:9042 -p 10.63.160.170:9160:9160 -it -d 3aad9985ad40 tail -f /dev/null
