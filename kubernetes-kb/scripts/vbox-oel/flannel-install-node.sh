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

kubectl apply -f /root/kubeinstall/kube-flannel.yml
