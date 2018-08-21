cd /VboxVMDisks/rac1
VBoxManage storageattach rac1n2 --storagectl "SATA" --port 1 --device 0 --type hdd --medium rac1_asmdata01.vmdk --mtype shareable
VBoxManage storageattach rac1n2 --storagectl "SATA" --port 2 --device 0 --type hdd --medium rac1_asmdata02.vmdk --mtype shareable
VBoxManage storageattach rac1n2 --storagectl "SATA" --port 3 --device 0 --type hdd --medium rac1_asmdata03.vmdk --mtype shareable
VBoxManage storageattach rac1n2 --storagectl "SATA" --port 4 --device 0 --type hdd --medium rac1_asmdata04.vmdk --mtype shareable
