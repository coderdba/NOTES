CLOUD-INIT. 
Cloud-init is NOT called by packer - it is called ONLY when the VM actually comes up as a real VM.  

CLOUD-INIT PACKAGE. If you want to install then add a line to the packer json under shell provisioner - "yum install -y cloud-init".  
--> HOWEVER, then the resulting qcow cannot be used for creating another qcow - only virt-install can use qcow to create a VM.  

TBD/ISSUES:  
qemu-args cdrom seems to be not mounting the iso file.  
- or, I dont know the mount point to use.  
