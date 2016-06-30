#!/bin/ksh
#---------------------------------------------------------------------------------------------------
#  To create Oracle RAC Database
#  
#
#--------------------------------------------------------------------------------------------------

export script=$0

export DBNAME=DB1  #Can be parametrized
export DBNAME_UNIQUE=DB1_SITE1 #Can be derived from DBNAME if standardized
export PDBNAME=P1
export ARCHIVELOGMODE=YES

echo "INFO - Starting $script" `date`
echo

echo "INFO - Setting environment and variables"
echo
export ORACLE_HOME=/oracle/db/product/12.1.0.2
export ORACLE_BASE=/oracle/db
export GRID_HOME=/oracle/grid/12.1.0.2
export GRID_BASE=/oracle/grid
export TNS_ADMIN=/usr/local/tns
export TNS_FILE=$TNS_ADMIN/tnsnames.ora
export PATH=/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:/usr/bin/X11:/sbin:$ORACLE_HOME/bin:.
export oratab=/etc/oratab
export listenerora=$TNS_ADMIN/listener.ora
export tnsnamesora=$TNS_ADMIN/tnsnames.ora
export RACNODES=`$GRID_HOME/bin/onsnodes`  #This gives space-delimited list
export RACNODES=`echo $RACNODES | sed 's/ /,/g'`  #Change space to comma delimited
export RACCLUSTERNAME=`$GRID_HOME/bin/cemutlo -n`
export RACSCANNAME=`srvctl config scan |grep "SCAN name:" | cut -d: -f2 |cut -d, -f1 |sed 's/ //g'`

echo "INFO - Listing environment:"
env |sort

echo
echo "INFO - Creating Database using DBCA command"
echo
dbca -silent -createDatabase -gdbName $DBNAME_UNIQUE -sid $DBNAME -nodelist $RACNODES -databaseType MULTIPURPOSE -characterSet AL32UTF8 -nationalCharacterSet AL16UTF16 -initParams db_name=$DBNAME,db_unique_name=$DBNAME_UNIQUE,db_block_size=8 -templatename General_Purpose.dbc -sysPassword sys123 -systemPassword system123 -createAsContainerDatabase true -numberOfPdbs 1 -pdbName $PDBNAME -pdbAdminUserName PDBADMIN -pdbAdminPassword pdbadmin123 -storageType ASM -diskGroupName DATA01 -recoveryGroupName FRA01 -redoLogFileSize 100M -emConfiguration NONE -sampleSchema false 

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

if [$ARCHIVELOGMODE="YES"]
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

# NOTE - A verify-function is already created upon db creation.  
#        NO NEED to run this
#        This 'common' verify function can be used for local users also
#echo "INFO - Creating Verify Function"
#sqlplus / as sysdba <<EOF
#whenever sqlerror exit 1
#@$ORACLE_HOME/rdbms/admin/utlpwdmg.sql
#EOF

#if [$# -ne 0]
#then
#echo "INFO - Error while creating verify function"
##exit 1  #Probably we dont need to exit, instead, fix later
#fi

# TODO - apply psu
# Restart the db to clean up any processes
srvctl stop database -d $DBNAME_UNIQUE 
srvctl start database -d $DBNAME_UNIQUE
sqlplus -s / <<EOF
@$ORACLE_HOME/rdbms/admin/catbundle.sql psu apply
EOF

# Create/alter 'common' profiles, users etc
sqlplus -s / <<EOF
show con_name;

-- Setup AWR settings
exec dbms_workload_repository.modify_snapshot_settings (interval => 60);
exec dbms_workload_repository.modify_snapshot_settings (retention => 30*24*60);

-- profile for system/internal users
create profile c##internal_user_profile limit
        PASSWORD_LIFE_TIME 90
        PASSWORD_REUSE_MAX 3
        FAILED_LOGIN_ATTEMPTS 6
        PASSWORD_LOCK_TIME .0209
        PASSWORD_GRACE_TIME 7
        password_verify_function ORA12C_STRONG_VERIFY_FUNCTION;
        
-- generic app user profile will have unlimited life time so that apps do not go down due to password expiry
create profile c##generic_user_profile limit
  PASSWORD_LIFE_TIME UNLIMITED 
  PASSWORD_REUSE_MAX 10
  FAILED_LOGIN_ATTEMPTS 6
  PASSWORD_LOCK_TIME .0209
  PASSWORD_GRACE_TIME unlimited
  password_verify_function ORA12C_STRONG_VERIFY_FUNCTION;
  
-- named user profile will have more strict limits - like 90 day password expiry, reuse, failed attempts etc
create profile c##named_user_profile limit
  PASSWORD_LIFE_TIME 90
  PASSWORD_REUSE_MAX 3
  FAILED_LOGIN_ATTEMPTS 3
  PASSWORD_LOCK_TIME .0209
  PASSWORD_GRACE_TIME 7
  password_verify_function ORA12C_STRONG_VERIFY_FUNCTION;

-- dba user profile is for dba like users with elevated privileges
create profile c##elevated_user_profile limit
        PASSWORD_LIFE_TIME 90
        PASSWORD_REUSE_MAX 3
        FAILED_LOGIN_ATTEMPTS 3
        PASSWORD_LOCK_TIME .0209
        PASSWORD_GRACE_TIME 7
        password_verify_function ORA12C_STRONG_VERIFY_FUNCTION;

-- DBSNMP profile - for dbsnmp user
create profile c##dbsnmp_profile limit
        PASSWORD_LIFE_TIME 90
        PASSWORD_REUSE_MAX 3
        FAILED_LOGIN_ATTEMPTS 3
        PASSWORD_LOCK_TIME .0209
        PASSWORD_GRACE_TIME 7
        password_verify_function ORA12C_STRONG_VERIFY_FUNCTION
        COMPOSITE_LIMIT UNLIMITED
        IDLE_TIME UNLIMITED
        CONNECT_TIME UNLIMITED;
        
--
--  SET THE RIGHT PROFILE FOR INTERNAL USERS
--
alter user SYS profile c##internal_user_profile;
alter user SYSTEM profile c##internal_user_profile;
alter user ORDSYS profile c##internal_user_profile;
alter user DBSNMP profile c##internal_user_profile;
--- similarly set profile for other internal users also
---
---

EOF

# Create/alter local user/profile etc in PDB
sqlplus '/ as sysdba' <<EOF

alter session set container = $PDB_NAME;
show con_name;

alter user PDBADMIN profile c##internal_user_profile;

create user oemperfuser identified by PERF#USER99
default tablespace users temporary tablespace temp profile c##generic_user_profile;

grant select_catalog_role to oemperfuser;
grant advisor to oemperfuser;
grant create session to oemperfuser;
grant oem_monitor to oemperfuser;
grant wm_admin_role to oemperfuser;
grant scheduler_admin_role to oemperfuser;

--
-- create more users as required
--

EOF

# TODO - (may not be needed) Local password verify function for PDB and assign it to DEFAULT profile of PDB

# TODO - custom init.ora settings
# TODO - Install additional packages - like Java etc

# create a tns entry for DB and its PDBs
# TODO - in this, add steps to find the $scan-name and $pdbServiceName
echo "
PDB1 =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = $scan-name)(PORT = 1522))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = $pdbServiceName)
    )
  )
" >> $TNS_FILE

# TODO - verify srvctl configuration

# TODO - create utility users - common/local
# TODO - create additional tablespaces
# TODO - create additional default users
# TODO - create cloud schemas
# TODO - create cloud control table
# TODO - register with RMAN
# TODO - register with OEM
