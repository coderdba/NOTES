# setenforce 0

Edit the file /etc/sysconfig/selinux and set enforcing as disabled

---------------------------------
DISABLE SWAP
---------------------------------
# swapoff -a

Edit /etc/fstab and comment out line of swap
#/dev/mapper/ol-swap     swap                    swap    defaults        0 0

---------------------------------
ENABLE br_netfilter
---------------------------------
# modprobe br_netfilter
# echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

- INSTALL DOCKER
Check, and install if needed - dependencies with the following command:
# yum install -y yum-utils device-mapper-persistent-data lvm2

Next, add the Docker-ce repository with the command:
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

Install Docker-ce with the command:
# yum install -y docker-ce

- ENABLE DOCKER SERVICE
# systemctl enable docker

- START DOCKER
# service docker start

- CHECK CGROUP
# docker info | grep -i cgroup
Cgroup Driver: cgroupfs

- Create yum repo
Create file: /etc/yum.repos.d/kubernetes.repo
With content:
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
        
# yum install -y kubelet kubeadm kubectl
