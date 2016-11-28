#!/bin/ksh
#---------------------------------------------------------------------------------------------------
#  To create Oracle RAC Database
#
#  Disclaimer:  Syntax and other errors may exist in this program.
#               Author not responsible for the actions of this program, good or bad.
#
#  TODO and CHECK:  Search for TODO and CHECK for incomplete sections
#
#  NOTES:
#  1. Customize password-verify-function as needed in utlpwdmg.sql before running this script
#
#
#--------------------------------------------------------------------------------------------------

export script=$0

export DBNAME=DB12C1  #Can be parametrized
export DBNAME_UNIQUE=${DBNAME}_P #Can be derived from DBNAME if standardized
export PDBNAME=${DBNAME}PD1
export ARCHIVELOGMODE=YES

echo "INFO - Starting $script" `date`
echo

echo "INFO - Setting environment and variables"
echo
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2.RAC
export ORACLE_BASE=/u01/app/oracle
export GRID_HOME=/u01/app/12.1.0.2.GRD
export GRID_BASE=/u01/app/grid
export TNS_ADMIN=/usr/local/tns
export TNS_FILE=$TNS_ADMIN/tnsnames.ora
export PATH=/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:/usr/bin/X11:/sbin:$ORACLE_HOME/bin:.
export oratab=/etc/oratab
export listenerora=$TNS_ADMIN/listener.ora
export tnsnamesora=$TNS_ADMIN/tnsnames.ora
export RACNODES=`$GRID_HOME/bin/olsnodes`  #This gives space-delimited list
export RACNODES=`echo $RACNODES | sed 's/ /,/g'`  #Change space to comma delimited
export RACCLUSTERNAME=`$GRID_HOME/bin/cemutlo -n`
export RACSCANNAME=`srvctl config scan |grep "SCAN name:" | cut -d: -f2 |cut -d, -f1 |sed 's/ //g'`

echo "INFO - Listing environment:"
env |sort

echo
echo "INFO - Creating Database using DBCA command"
echo
dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $DBNAME -nodelist $RACNODES -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,db_block_size=8 -templatename General_Purpose.dbc -sysPassword sys123 -systemPassword system123 -createAsContainerDatabase true -numberOfPdbs 1 -pdbName $PDBNAME -pdbAdminUserName PDBADMIN -pdbAdminPassword pdbadmin123 -storageType ASM -diskGroupName DATA_DG01 -recoveryGroupName FRA_DG01 -redoLogFileSize 10 -emConfiguration NONE -sampleSchema false

if [$# -ne 0]
then
echo "ERR - Error while creating database using DBCA command"
exit 1
fi

echo "INFO - Opening the PDB and saving open state"
sqlplus / as sysdba <<EOF
        whenever sqlerror exit 1
        alter pluggable database $PDBNAME open instances=all;
        alter pluggable database $PDBNAME save state instances=all;

        select con_id, name, inst_id, open_mode from gv$pdbs order by 1,2,3;
EOF

if [$? -ne 0]
then
echo "ERR - Error while opening PDB"
exit 1
fi

echo "INFO - Listing DB configuration using srvctl config database -d $DBNAME_UNIQUE"
srvctl config database -d $DBNAME_UNIQUE

if [ $ARCHIVELOGMODE = "YES" ]
then
echo "INFO - Setting archivelog mode"

sqlplus / as sysdba <<EOF
whenever sqlerror exit 1
alter database archivelog;
EOF

        if [$? -ne 0]
        then
        echo "ERR - Error while setting archivelog mode"
        #exit 1  #Probably we dont need to exit, instead, fix later
        else
        echo "INFO - Setting archivelog mode successful"
        echo
        fi

else
echo "INFO - Not setting archivelog mode"
echo
fi
