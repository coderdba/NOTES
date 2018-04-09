export DBNAME=CDB1
export DBNAME_UNIQUE=CDB1_SITE1
export PDBNAME=CDB1PDB1
export RACNODES=node1-hostname,node2-hostname # obtain these using 'olsnodes'

export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

/u02/app/oracle/product/12.1.0.2/bin/dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $DBNAME -nodelist $RACNODES -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,db_block_size=8192,sga_target=4096M -templatename General_Purpose.dbc -sysPassword sys123 -systemPassword system123 -createAsContainerDatabase true -numberOfPdbs 1 -pdbName $PDBNAME -pdbAdminUserName PDBADMIN -pdbAdminPassword pdbadmin123 -storageType ASM -diskGroupName DATA_DG01 -recoveryGroupName FRA_DG01 -redoLogFileSize 10 -emConfiguration NONE -sampleSchema false
