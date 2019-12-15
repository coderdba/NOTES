  
echo INFO - installing kubelet
yum install -y kubelet-1.15.5-0

echo INFO - installing kubectl
yum install -y kubectl-1.15.5-0

echo INFO - installing kubeadm
yum install -y kubeadm-1.15.5-0

echo INFO - installing kubernetes-cni
yum install kubernetes-cni-0.7.5-0

echo
echo
echo verifying
echo
rpm -qa |grep kube
which kubelet
which kubectl
which kubeadm
