./derive1-destroy.sh
./seed-iso-virt-install-create.sh

root_disk_path=/var/lib/vm/gm1-root.qcow2
seed_file_path=/var/lib/packer-work/repos/centos7-gm1/seed-virt-install.iso
image_file=/var/lib/packer-work/images/centos7-gm1-derive1-0.0.1.qcow2

cp $image_file $root_disk_path

# virt-install \
#   --name=$vm_name \
#   --ram=$MEM \
#   --vcpus=$CPU \
#   --disk path=${root_disk_path},format=qcow2 \
#   --disk path=${docker_disk_path},format=qcow2 \
#   --disk path=${etcd_disk_path},format=qcow2 \
#   --disk path=${certs_disk_path},format=qcow2 \
#   --disk path=${inject_files_path},format=RAW \
#   --disk path=${shared_disk_path},format=RAW \
#   --disk path=${local_persistent_disk_path},format=qcow2 \
#   --disk path=${seed_path},device=cdrom \
#   --network bridge=br30,model=virtio \
#   --network bridge=br30,model=virtio \
#   --os-type=linux \
#   --os-variant rhel7 \
#   --nographics \
#   --import

virt-install \
  --name=gm1 \
  --ram=1024 \
  --vcpus=2 \
  --disk path=${root_disk_path},format=qcow2 \
  --disk path=${seed_file_path},device=cdrom \
  --network bridge=br0,model=virtio \
  --network bridge=br0,model=virtio \
  --os-type=linux \
  --os-variant rhel7 \
  --nographics \
  --import
