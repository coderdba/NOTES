NEW METHOD
On Primary,
Get the location of password file using .srvctl config database .d
primary_db_unique_name.

Then, copy the password file to a filesystem file:
ASMCMD> pwcopy +DATA_DG01/DBUNIQUENAME_PRIM/PASSWORD/pwddbUniqueName_prim.560.877909231
/tmp/orapwrprimary
copying +DATA_DG01/DBUNIQUENAME_PRIM/PASSWORD/pwddbUniqueName_pri.560.877909231 ->
/tmp/orapwprimary

Copy the f/s file to standby



OLD METHOD
#orapwd FILE=/u01/app/oracle/product/12.1.0.2.RAC/dbs/orapwDB_INST_NAME_PRIM ENTRIES=20 FORMAT=12
#Enter password for SYS:  <give the sys password>

orapwd FILE=/tmp/orapwfile ENTRIES=20 FORMAT=12
