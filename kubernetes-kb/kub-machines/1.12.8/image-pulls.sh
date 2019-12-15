docker pull quay.io/coreos/etcd:v3.3.10
docker pull quay.io/coreos/etcd:v3.2.24

docker pull gcr.io/google_containers/kube-apiserver-amd64:v1.12.8
docker pull gcr.io/google_containers/kube-scheduler-amd64:v1.12.8 
docker pull gcr.io/google_containers/kube-controller-manager-amd64:v1.12.8
docker pull gcr.io/google_containers/kube-proxy-amd64:v1.12.8
docker pull k8s.gcr.io/pause-amd64:3.1 

docker pull k8s.gcr.io/k8s-dns-kube-dns:1.14.13
docker pull k8s.gcr.io/k8s-dns-dnsmasq-nanny:1.14.13
docker pull k8s.gcr.io/k8s-dns-sidecar:1.14.13

# being used with kubernetes 1.12.8
docker pull quay.io/coreos/flannel:v0.9.0-amd64 

# latest as in kube-flannel.yml 
docker pull quay.io/coreos/flannel:v0.11.0-amd64 

# some other images for testing and utility
docker pull busybox
docker pull nginx

echo
echo
echo VERIFY
echo
docker images

