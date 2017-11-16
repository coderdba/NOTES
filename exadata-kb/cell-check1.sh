echo "INFO - Uptime"
dcli -l root -g cell_group uptime

echo "INFO - ---------------------------------------------------------------------------------"

echo "INFO - Cell Fault"
dcli -l root -g cell_group 'ipmitool sunoem cli "show faulty"'


echo "INFO - ---------------------------------------------------------------------------------"

echo "INFO - Cell ASMDisk Count"
dcli -l root -g cell_group cellcli -e "list griddisk attributes name,asmmodestatus,asmdeactivationoutcome  |grep ONLINE | wc -l"


echo "INFO - ---------------------------------------------------------------------------------"

echo "INFO - Cell Service Status"
dcli -l root -g cell_group  "service celld status"


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Cell ASMDisk Status"
dcli -l root -g cell_group cellcli -e "list griddisk attributes name,asmmodestatus,asmdeactivationoutcome"


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - GridDisk Status"
dcli -l root -g /root/cell_group "cellcli -e list griddisk"


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - CellDisk Status"
dcli -l root -g cell_group cellcli -e "list celldisk"


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - PhysicalDisk Status"
dcli -l root -g cell_group cellcli -e "list physicaldisk"


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - FlashCache Status"
dcli -l root -g cell_group cellcli -e "list flashcache"


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - Image Version"
dcli -l root -g cell_group imageinfo | grep "Active image version"


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Exadata alert"

dcli -l root -g ~/cell_group "cellcli -e list metriccurrent where alertState!=\'Normal\'"



echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Exadata cell CPU utilization"

dcli -l root -g ~/cell_group "cellcli -e list metriccurrent CL_CPUT"


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - Exadata cells flashdisk with status NOT present"

dcli -l root -g ~/cell_group "cellcli -e list physicaldisk attributes name, id, slotnumber where disktype=\"flashdisk\" and status=\'not present\'"


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - Exadata cell current temperature"

dcli -l root -g ~/cell_group 'cellcli -e list cell detail' | egrep temperature


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - Exadata alert history"

dcli -l root -g ~/cell_group "cellcli -e list metrichistory where alertState!=\'Normal\'"


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Exadata cells battery replacement checks"

dcli -l root -g ~/cell_group '/opt/MegaRAID/MegaCli/MegaCli64 -adpbbucmd -aALL' |grep replaced


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - Exadata cells harddisk with status NOT present"

dcli -l root -g ~/cell_group "cellcli -e list physicaldisk attributes name, id, slotnumber where disktype=\"harddisk\" and status=\'not present\'"


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Exadata cells services checks"

dcli -l root -g ~/cell_group 'cellcli -e list cell detail' | egrep '(cellsrvStatus)|(msStatus)|(rsStatus)'


echo "INFO - ---------------------------------------------------------------------------------"



echo "INFO - Exadata cells memory checks"

dcli -l root -g ~/cell_group --vmstat="-a 3 2"


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Exadata physical disk checks"

dcli -g ~/all_group -l root /opt/MegaRAID/MegaCli/MegaCli64 AdpAllInfo -aALL | grep "Device Present" -A 8


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Exadata cell fan status"

dcli -l root -g ~/cell_group 'cellcli -e list cell detail' | egrep fan


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Exadata storage cell model detail"

dcli -l root -g ~/cell_group 'cellcli -e list cell detail' | egrep makeModel


echo "INFO - ---------------------------------------------------------------------------------"


echo "INFO - Exadata cells power status"

dcli -l root -g ~/cell_group 'cellcli -e list cell detail' | egrep power
