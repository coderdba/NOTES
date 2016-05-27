set echo on

Alter system set  dg_broker_config_file1='+DATA_DG01/DBUNIQUENAME_PRIM/DATAGUARDCONFIG/dg_config_file1.dat' scope=both;
Alter system set dg_broker_config_file2='+FRA_DG01/DBUNIQUENAME_PRIM/DATAGUARDCONFIG/dg_config_file2.dat' scope=both;
Alter system set dg_broker_start=TRUE scope=both;
ALTER SYSTEM SET LOG_ARCHIVE_DEST_2='' scope=both;
