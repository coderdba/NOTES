
dcli -l root -g /root/dbs_group "dbmcli -e alter dbserver validate configuration"
dcli -l root -g /root/dbs_group "imageinfo" | egrep 'Image version:'
dcli -l root -g /root/dbs_group "imageinfo" | egrep 'Kernel version:'
dcli -l root -g /root/vm_group "/u01/app/12.1.0.2/grid/bin/olsnodes -c" | sort -k2
dcli -l root -g /root/vm_group "imageinfo" | egrep 'Image version:'
dcli -l root -g /root/vm_group "imageinfo" | egrep 'Kernel version:'
dcli -l root -g /root/vm_group 'su - oracle -c "/u01/app/oracle/product/12.1.0.2/dbhome_1/OPatch/opatch lspatches -oh /u01/app/oracle/product/12.1.0.2/dbhome_1"' | egrep '12.1.0.2.180116'
dcli -l root -g /root/vm_group "df /u01/app/oracle/product/11.2.0.4/dbhome_1/" | egrep 'Available'
dcli -l root -g /root/vm_group 'su - oracle -c "/u01/app/oracle/product/11.2.0.4/dbhome_1/OPatch/opatch lspatches -oh /u01/app/oracle/product/11.2.0.4/dbhome_1"' | egrep '11.2.0.4.180116'

##---> 12.2 checks

dcli -l root -g /root/vm_group '/u01/app/12.1.0.2/grid/bin/crsctl query crs activeversion'
dcli -l root -g /root/vm_group "/u02/app/12.2.0.1/grid/bin/crsctl query crs softwareversion -all"
dcli -l root -g /root/vm_group "/u02/app/12.2.0.1/grid/bin/crsctl config crs"
dcli -l root -g /root/vm_group "cat /u01/app/oraInventory/ContentsXML/inventory.xml | egrep '12.2.0.1' | egrep 'GI'"
dcli -l root -g /root/vm_group 'su - ororgrid -c "/u01/app/12.2.0.1/grid/OPatch/opatch lspatches -oh /u01/app/12.2.0.1/grid" ' | egrep '12.2.0.1.180116'
dcli -l root -g /root/vm_group "/u01/app/12.2.0.1/grid/bin/crsctl status resource -t -w 'TYPE = ora.database.type'"
dcli -l root -g /root/vm_group "/u01/app/12.2.0.1/grid/bin/crsctl status resource -t -w 'TYPE = ora.service.type'"
dcli -l root -g /root/vm_group "/zfssa/root/scripts/check_service_status.sh | egrep -i 'DISABLED'"
dcli -l root -g /root/vm_group 'su - ororgrid -c "lsnrctl status LISTENER_SCAN1| egrep 'Service' | egrep -v 'E'" ' | egrep 'Service'
dcli -l root -g /root/vm_group 'su - ororgrid -c "lsnrctl status LISTENER_SCAN2| egrep 'Service' | egrep -v 'E'" ' | egrep 'Service'
dcli -l root -g /root/vm_group "/zfssa/root/scripts/check_service_status.sh | egrep -i 'DISABLED'"
dcli -l root -g /root/vm_group 'su - oemagent -c "/u01/app/oemagent/core/12.1.0.5.0/bin/emctl status agent" ' | egrep 'Running'
dcli -l root -g /root/vm_group 'su - grid -c "/root/scripts/list_active_services.sh"'
dcli -l root -g /root/vm_group "/zfssa/root/scripts/check_service_status.sh | egrep 'ONLINE' "
dcli -l root -g /root/vm_group " ps -ef | grep pmon" | egrep MGMTDB

#----------------------------
#----cell checks
#----------------------------
dcli -l root -g /root/cell_group 'imageinfo -version'
dcli -l root -g /root/cell_group 'imageinfo -status'
dcli -l root -g /root/cell_group 'uname -r'
dcli -l root -g /root/cell_group 'cellcli -e list cell'
dcli -l root -g /root/cell_group 'cellcli -e list cell detail | grep release'
dcli -l root -g /root/cell_group '/opt/oracle.cellos/CheckHWnFWProfile'
dcli -g cell_group -l root 'cellcli -e ALTER CELL VALIDATE CONFIGURATION'
dcli -g /root/cell_group -l root '/usr/local/bin/ipconf -verify -semantic'
dcli -l root -g cell_group "cellcli -e list griddisk attributes name, status, asmmodestatus, asmdeactivationoutcome" | wc -l
dcli -l root -g cell_group "cellcli -e list griddisk attributes name, status, asmmodestatus, asmdeactivationoutcome" | egrep -i 'not' | wc -l
dcli -g /root/cell_group -l root 'cellcli -e list alerthistory'


#----------------------------
#----IB checks
#----------------------------
dcli -l root -g /root/ib_group "version | grep version"
dcli -l root -g /root/ib_group "env_test | grep 'Environment test'"
dcli -l root -g /root/ib_group "showunhealthy"
dcli -l root -g /root/ib_group "checkboot"
dcli -l root -g cell_group "cellcli -e LIST IBPORT DETAIL | egrep 'name:|physLinkState:' "

#---------------------------------------------------------------
#---DBMS 'Bundle Patch Checks' 
#---------------------------------------------------------------
/u01/app/oracle/product/12.1.0.2/dbhome_1/OPatch/opatch lspatches -oh /u01/app/oracle/product/12.1.0.2/dbhome_1
/u01/app/oracle/product/11.2.0.4/dbhome_1/OPatch/opatch lspatches -oh /u01/app/oracle/product/11.2.0.4/dbhome_1

#---------------------------------------------------------------
#---GRID 12.2 'Bundle Patch Checks' 
#---------------------------------------------------------------
dcli -l root -g /root/vm_group 'su - grid -c "/u01/app/12.2.0.1/grid/OPatch/opatch lspatches -oh /u01/app/12.2.0.1/grid -oh /u01/app/12.2.0.1/grid"'
