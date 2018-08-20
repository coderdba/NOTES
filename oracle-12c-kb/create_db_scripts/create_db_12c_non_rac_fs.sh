# CREATE 12C NON-RAC DB ON FILESYSTEM

export DBNAME=ORANR2
export SID=ORANR2
export DBNAME_UNIQUE=ORANR2_SITE1
export PDBNAME=PDB1

export ORACLE_HOME=/u01/app/oracle/product/12.1.0/dbhome_1
export LD_LIBRARY_PATH=$ORACLE_HOME/lib

export PATH=/u01/app/oracle/product/12.1.0/dbhome_1/perl/bin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/oracle/.local/bin:/home/oracle/bin:/u01/app/oracle/product/12.1.0/dbhome_1/bin

/u01/app/oracle/product/12.1.0/dbhome_1/bin/dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $SID -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,db_block_size=8192,sga_target=2048M -templatename General_Purpose.dbc -sysPassword Oracle_123 -systemPassword Oracle_123 -createAsContainerDatabase true -numberOfPdbs 1 -pdbName $PDBNAME -pdbAdminUserName PDBADMIN -pdbAdminPassword Oracle_123 -storageType FS -datafileDestination /oradata/data -recoveryAreaDestination /oradata/fra -redoLogFileSize 100 -emConfiguration NONE -sampleSchema false
