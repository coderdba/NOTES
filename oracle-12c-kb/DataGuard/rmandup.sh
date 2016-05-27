#-- DBUNIQUENAME_PRIM - Primary unique name
#-- DBUNIQUENAME_STBY  - Standby unique name

 nohup rman target sys/syspassword@prim-cluster-vip1/DBUNIQUENAME_PRIM auxiliary sys/syspassword@stby-cluster-vip1/DBUNIQUENAME_STBY @rmandup.cmd &
