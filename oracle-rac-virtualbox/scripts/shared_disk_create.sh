# Go to the shared disks directory
mkdir -p /VboxVMDisks/rac1
cd /VboxVMDisks/rac1

# Create hard disks
VBoxManage createhd --filename rac1_asmdata01.vmdk --size 12288 --format VMDK --variant Fixed
VBoxManage createhd --filename rac1_asmdata02.vmdk --size 12288 --format VMDK --variant Fixed
VBoxManage createhd --filename rac1_asmdata03.vmdk --size 12288 --format VMDK --variant Fixed
VBoxManage createhd --filename rac1_asmdata04.vmdk --size 12288 --format VMDK --variant Fixed

# Connect them to the VM.
VBoxManage storageattach rac1n1 --storagectl "SATA" --port 1 --device 0 --type hdd --medium rac1_asmdata01.vmdk --mtype shareable
VBoxManage storageattach rac1n1 --storagectl "SATA" --port 2 --device 0 --type hdd --medium rac1_asmdata02.vmdk --mtype shareable
VBoxManage storageattach rac1n1 --storagectl "SATA" --port 3 --device 0 --type hdd --medium rac1_asmdata03.vmdk --mtype shareable
VBoxManage storageattach rac1n1 --storagectl "SATA" --port 4 --device 0 --type hdd --medium rac1_asmdata04.vmdk --mtype shareable

# Make shareable.
VBoxManage modifyhd rac1_asmdata01.vmdk --type shareable
VBoxManage modifyhd rac1_asmdata02.vmdk --type shareable
VBoxManage modifyhd rac1_asmdata03.vmdk --type shareable
VBoxManage modifyhd rac1_asmdata04.vmdk --type shareable
