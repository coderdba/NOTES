# v 1.0 image
docker run --privileged --name cassandraonex1 -v /sys/fs/cgroup:/sys/fs/cgroup:ro  -p 127.0.0.1:9042:9042 -p 127.0.0.1:9160:9160 -it -d 16a4fa066ab8
#docker run --privileged --name cassandraonex1 -v /sys/fs/cgroup:/sys/fs/cgroup:ro  -p 101.63.160.170:9042:9042 -p 101.63.160.170:9160:9160 -it -d 16a4fa066ab8
