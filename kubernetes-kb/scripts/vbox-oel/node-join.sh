echo INFO - First edit /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
echo  and add --node-ip directive

echo
echo SLEEPING 100 SECONDS FOR YOU TO EDIT THE FILE
sleep 100

mkdir -p /root/.kube
scp k00:/root/.kube/config /root/.kube/config

echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
cat /proc/sys/net/bridge/bridge-nf-call-iptables

systemctl enable kubelet
systemctl enable docker
systemctl daemon-reload
service docker start

kubeadm join 192.168.11.100:6443 --token s8gwke.yxate9aj24yygbhu --discovery-token-ca-cert-hash sha256:ea6d4afd5ae0e4a002d6a1c609dd121f4756e01390d30103b91591e1bf9c6519 --ignore-preflight-errors=all
