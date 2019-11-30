# NOTES
## CLOUD-INIT  
Cloud-init is NOT called by packer - it is called ONLY when the VM actually comes up as a real VM.  
  
## CLOUD-INIT PACKAGE. 
If you want to install then add a line to the packer json under shell provisioner - "yum install -y cloud-init".   
--> HOWEVER, then the resulting qcow cannot be used for creating another qcow - only virt-install can use qcow to create a VM. 

## CLOUD-INIT - REMOVE AFTER USE. 
Once a VM is created using the qcow, if we dont want cloud-init to fire again, then remove cloud-init package from the vm.  
--> This can be done in the cloud-init script itself - like 'user-data'

# TBD/ISSUES:  
qemu-args cdrom seems to be not mounting the iso file. 
- or, I dont know the mount point to use. 

# RUN SEQUENCE
base-run.sh --> creates base image from iso - based on base-ks.cfg and base-packer.json - using DVD iso of the OS. 

derive1-run.sh --> creates an image with cloud-init package installed - based on the base image created by base-run.sh. 
- uses derive-packer.json
- This mounts an iso file in json, but the user-data file in that iso does not really run - so, it is a DUMMY. 

derive1-virt-install.sh --> creates an actual VM based on the image created by derive1-run.sh.  
- This uses iso file seed-virt-install.iso created by seed-iso-virt-install-create.sh - with files in seed-virt-install folder. 

