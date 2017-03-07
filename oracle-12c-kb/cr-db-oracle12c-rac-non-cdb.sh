export DBNAME=NONCDB1
export DBNAME_UNIQUE=NONCDB1_SITE1
export RACNODES=node1,node2  # get these using 'olsnodes' command

export ORACLE_HOME=/u02/app/oracle/product/12.1.0.2
export LD_LIBRARY_PATH=$ORACLE_HOME/lib


/u01/app/oracle/product/12.1.0.2/bin/dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $DBNAME -nodelist $RACNODES -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,db_block_size=8,sga_target=4096 -templatename General_Purpose.dbc -sysPassword sys123 -systemPassword system123 -createAsContainerDatabase false -storageType ASM -diskGroupName DATA_DG01 -recoveryGroupName FRA_DG01 -redoLogFileSize 10 -emConfiguration NONE -sampleSchema false
