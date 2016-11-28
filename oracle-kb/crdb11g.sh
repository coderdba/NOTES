#!/bin/ksh
#---------------------------------------------------------------------------------------------------
#  To create Oracle RAC Database
#
#
#--------------------------------------------------------------------------------------------------

exec > crdb11g.sh.out 2>> crdb11g.sh.out

export script=$0

export DBNAME=DB11G1  #Can be parametrized
export DBNAME_UNIQUE=${DBNAME}_SITE1

export PDBNAME=P1
export ARCHIVELOGMODE=YES

echo "INFO - Starting $script" `date` " to create DB $DBNAME, Unique Name $DBNAME_UNIQUE"
echo

echo "INFO - Setting environment and variables"
echo
#export ORACLE_HOME=/oracle/db/product/12.1.0.2
#export ORACLE_BASE=/oracle/db
#export GRID_HOME=/oracle/grid/12.1.0.2
#export GRID_BASE=/oracle/grid
#export TNS_ADMIN=/usr/local/tns
export GRID_BASE=/u01/app/grid
export GRID_HOME=/u01/app/12.1.0.2.GRD
export ORACLE_SID=${DBNAME}1
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4.RAC
export TNS_ADMIN=$GRID_HOME/network/admin
export TNS_FILE=$TNS_ADMIN/tnsnames.ora
export PATH=/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:/usr/bin/X11:/sbin:$ORACLE_HOME/bin:.
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
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
dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $DBNAME -nodelist $RACNODES -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,db_block_size=8 -templatename General_Purpose.dbc -sysPassword sys123 -systemPassword system123 -storageType ASM -diskGroupName DATA_DG01 -recoveryGroupName FRA_DG01 -redoLogFileSize 50 -emConfiguration NONE -sampleSchema false

if [ $? -ne 0 ]
then
echo "ERR - Error while creating database using DBCA command"
exit 1
fi

echo "INFO - Listing DB configuration using srvctl config database -d $DBNAME_UNIQUE"
srvctl config database -d $DBNAME_UNIQUE

if [ "$ARCHIVELOGMODE" = "YES" ]
then

echo "INFO - Setting archivelog mode"
echo "INFO - First stopping the database"

srvctl stop  database -d $DBNAME_UNIQUE

echo "INFO - Starting mount and setting archivelog"
sqlplus / as sysdba <<EOF
whenever sqlerror exit 1
startup mount;
alter database archivelog;
alter database open;
shutdown;
EOF

        if [ $? -ne 0 ]
        then
        echo "ERR - Error while setting archivelog mode"
        #exit 1  #Probably we dont need to exit, instead, fix later
        else
        echo "INFO - Setting archivelog mode successful"
        echo
        fi

echo "INFO - Restarting the database"
srvctl start  database -d $DBNAME_UNIQUE

else
echo "INFO - Not setting archivelog mode"
echo
fi


echo
echo "INFO - Applying PSU"
echo
srvctl stop database -d $DBNAME_UNIQUE
srvctl start database -d $DBNAME_UNIQUE
sqlplus -s / <<EOF
@$ORACLE_HOME/rdbms/admin/catbundle.sql psu apply
EOF

echo
echo "INFO - Creating some users and profiles"
echo
sqlplus -s / as sysdba <<EOF

create user user1 identified by user1 default tablespace users temporary tablespace temp;
grant connect, resource to user1;
alter user user1 quota unlimited on users;
create profile user_profile limit failed_login_attempts 100;
alter user user1 profile user_profile

EOF
