#LIST PHYSICALDISK
#LIST ALERTHISTORY

GROUP=/root/cell_group

echo CELL REPORT
echo 
echo ====================================
echo INFO - Listing physical disks
echo
dcli --serial -g $GROUP -l root 'su - celladmin -c "cellcli -e list physicaldisk"'

echo 
echo ====================================
echo INFO - Listing alert history
echo
dcli --serial -g $GROUP -l root 'su - celladmin -c "cellcli -e list alerthistory"'


echo 
echo ====================================
echo INFO - Post Patch Checks
echo

echo ====================================
echo
echo IMAGEINFO VERSION
echo
dcli -l root -g /opt/oracle.SupportTools/onecommand/cell_group imageinfo -version
echo ====================================
echo
echo IMAGEINFO STATUS
echo
dcli -l root -g /opt/oracle.SupportTools/onecommand/cell_group imageinfo -status
echo ====================================
echo
echo UNAME MINUS R
echo
dcli -l root -g /opt/oracle.SupportTools/onecommand/cell_group 'uname -r'
echo ====================================
echo
echo LIST CELL
echo
dcli -l root -g /opt/oracle.SupportTools/onecommand/cell_group cellcli -e list cell
echo ====================================
echo
echo LIST CELL DETAIL GREP RELEASE
echo
dcli -l root -g /opt/oracle.SupportTools/onecommand/cell_group 'cellcli -e list cell detail | grep release'
echo ====================================
echo
echo CHECK HW NFW PROFILE
echo
dcli -l root -g /opt/oracle.SupportTools/onecommand/cell_group /opt/oracle.cellos/CheckHWnFWProfile
echo ====================================
echo
echo ALERTHISTORY
echo
dcli -g cell_group -l root ""cellcli -e list alerthistory""
echo ====================================
echo
echo VALIDATE CONFIGURATION
echo
dcli -g cell_group -l root ""cellcli -e ALTER CELL VALIDATE CONFIGURATION""
echo ====================================
echo
echo IPCONF VERIFY SEMANTIC
echo
dcli -g cell_group -l root ""/usr/local/bin/ipconf -verify -semantic"""
