mkdir -p /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config

echo 1 > /proc/sys/net/bridge/bridge-nf-call-iptables
cat /proc/sys/net/bridge/bridge-nf-call-iptables

kubectl apply -f /root/kubeinstall/kube-flannel.yml
