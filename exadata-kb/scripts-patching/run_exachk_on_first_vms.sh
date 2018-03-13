exec > run_exachk_on_first_vms.sh.out 2>> run_exachk_on_first_vms.sh.out

dcli -l root -g ./vm_firstnode_group "/opt/oracle.SupportTools/exachk/exachk -dball"

#dcli -l root -c machine_with_no_databases "/opt/oracle.SupportTools/exachk/exachk -nordbms" 
