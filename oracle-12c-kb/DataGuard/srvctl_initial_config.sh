#!/bin/ksh -x
#
# Do an initial registration of standby and its INITIAL password file
#

srvctl add database -d DBUNIQUENAME_STBY -o /u01/app/oracle/product/12.1.0.2.RAC
srvctl modify database -d DBUNIQUENAME_STBY -pwfile '+DATA_DG01/DBUNIQUENAME_STBY/PASSWORD/orapwdbuniquenamestby'
srvctl config database -d DBUNIQUENAME_STBY

