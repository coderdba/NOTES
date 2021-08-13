export NODE1=192.168.99.101
export DATA_DIR="etcd-data"
export ETCD_IMAGE="k8s.gcr.io/etcd:3.4.13-0"

#--name etcd ${REGISTRY}:latest \

docker run \
  -p 2379:2379 \
  -p 2380:2380 \
  --volume=${DATA_DIR}:/etcd-data \
  --name etcd ${ETCD_IMAGE} \
  /usr/local/bin/etcd \
  --data-dir=/etcd-data --name node1 \
  --initial-advertise-peer-urls http://${NODE1}:2380 --listen-peer-urls http://0.0.0.0:2380 \
  --advertise-client-urls http://${NODE1}:2379 --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster node1=http://${NODE1}:2380
