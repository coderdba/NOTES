systemctl enable kubelet.service
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
kubeadm init --apiserver-advertise-address=192.168.11.100 --pod-network-cidr=192.168.0.0/16 --ignore-preflight-errors=all
