export NODE1=192.168.99.101

docker ps -a  | grep etcd

etcdctl --endpoints=http://${NODE1}:2379 member list
etcdctl --endpoints=http://${192.168.99.101}:2379 member list

docker exec etcd /bin/sh -c "export ETCDCTL_API=3 && /usr/local/bin/etcdctl member list"
