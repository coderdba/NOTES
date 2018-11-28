mkdir -p /root/.kube
scp k00:/root/.kube/config /root/.kube/config

echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat /proc/sys/net/bridge/bridge-nf-call-iptables

kubectl apply -f /root/kubeinstall/kube-flannel.yml
