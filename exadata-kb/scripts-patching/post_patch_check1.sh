echo
echo
echo ITEM-IMAGEINFO
dcli -l root -g /root/vm_group 'imageinfo -ver; imageinfo -status'
echo
echo ITEM-DB BUNDLE
dcli -l root -g /root/vm_group 'grep -i 180116 /u01/app/oracle/product/12.1.0.2/dbhome_1/cfgtoollogs/opatch/lsinv/lsinventory2018-04*'
echo
echo ITEM-GRID BUNDLE
dcli -l root -g /root/vm_group 'grep -i 180116 /u01/app/12.2.0.1/grid/cfgtoollogs/opatch/lsinv/lsinventory2018-04*'
echo
dcli -l root -g /root/vm_group 'df -h /zfs*/*/* | grep backup1'
echo
echo
echo ITEM-CRS ACTIVE VERSION
dcli -l root -g /root/vm_group "su - ororgrid -c \"crsctl query crs softwarepatch; crsctl query crs activeversion;crsctl query crs softwareversion;  crsctl query crs activeversion -f \" "
