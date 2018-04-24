export DBNAME=EXD85IMP2
export SID=EXD85IMP2
export DBNAME_UNIQUE=EXD85IMP2_TTC
export PDBNAME=P1
export RACNODES=exd85adm01vm02,exd85adm02vm02

export ORACLE_HOME=/u01/app/oracle/product/12.2.0.1/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

/u01/app/oracle/product/12.2.0.1/dbhome_1/bin/dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $SID -nodelist $RACNODES -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,db_block_size=8192,sga_target=4096M -templatename General_Purpose.dbc -sysPassword sys_ABC_123 -systemPassword sys_ABC_123 -createAsContainerDatabase true -numberOfPdbs 1 -pdbName $PDBNAME -pdbAdminUserName PDBADMIN -pdbAdminPassword Pdb_Admin_123 -storageType ASM -diskGroupName DATA1 -recoveryGroupName RECO1 -redoLogFileSize 100 -emConfiguration NONE -sampleSchema false
