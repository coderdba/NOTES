echo INFO - Disabling selinux
setenforce 0

echo
echo WARN - TBD - Edit /etc/sysconfig/selinux and set enforcing as disabled
echo

echo INFO - Disable swap
swapoff -a

echo
echo WARN - TBD - Edit /etc/fstab and comment out line of swap
echo

echo INFO - enable netfilter module
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

echo INFO - Install docker
yum install -y yum-utils device-mapper-persistent-data lvm2

Next, add the Docker-ce repository with the command:
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce
systemctl enable docker

echo INFO - Start docker
service docker start

echo INFO - check cgroup
docker info | grep -i cgroup

echo INFO - setup kubernetes yum repo

repofile=/etc/yum.repos.d/kubernetes.repo

echo "
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
" > $repofile    

echo INFO - Install kubernetes software
yum install -y kubelet kubeadm kubectl
