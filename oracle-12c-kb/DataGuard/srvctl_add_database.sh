#!/bin/ksh -x

srvctl add database -d DBUNIQUENAME_STBY -o /u01/app/oracle/product/12.1.0.2.RAC -p '+DATA_DG01/DBUNIQUENAME_STBY/spfileDBNAME.ora' -n DBNAME -r PHYSICAL_STANDBY -s mount
srvctl add instance -d DBUNIQUENAME_STBY -i INSTANCE_NODE1 -n node1
srvctl add instance -d DBUNIQUENAME_STBY -i INSTANCE_NODE2 -n node2
#srvctl modify database -d DBUNIQUENAME_STBY -pwfile +DATA_DG01/ASM/PASSWORD/pwdasm.410.877942093
srvctl config database -d DBUNIQUENAME_STBY
