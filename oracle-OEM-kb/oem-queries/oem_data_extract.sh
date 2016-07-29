#!/bin/ksh
#----------------------------------------------------------------------------------
#  This program collects data from oem repository
#
#  Inputs:
#  tnsnames.ora file generated in the vfiler location
#----------------------------------------------------------------------------------

#---------------------------------------
# FUNCTIONS BEGIN
#---------------------------------------

#---------------------------------------
# FUNCTIONS END
#---------------------------------------

#---------------------------------------
# MAIN PROGRAM BEGIN
#---------------------------------------

export script_name=$0

echo INFO - Starting script $script_name at `date`

export script_basename=`basename $0`
export script_dirname=`dirname $0`
export this_machine=`/bin/hostname`

#export ORACLE_HOME=/u02/app/oracle/product/11.2.0.4.RAC
export ORACLE_HOME=/opt/oracle/product/11.1.0.7.CL
export LD_LIBRARY_PATH=${ORACLE_HOME}/lib:${LD_LIBRARY_PATH}
export TNS_ADMIN=/net/vfiler-nfs03/vol/vol_DDBA_oracle_repo/qtr_repo/OPERATIONS/tnsnames

export PATH=/apps/oracle/OEM12cR4/Middleware/oms/bin:/apps/oracle/OEM12cR4/Middleware/oms/OPatch:/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:$ORACLE_HOME/bin:/usr/bin/X11:/sbin:.

#-------------------
# Directories
#-------------------
cd $script_dirname
cd ..
export script_basedir=`pwd`
export script_bindir=$script_basedir/bin
export script_tmpdir=$script_basedir/tmp
export script_logdir=$script_basedir/log
export script_envdir=$script_basedir/env
export script_errdir=$script_basedir/err
export script_datastoredir=$script_basedir/store


#---------
# DB cred
#---------
export sys_pass=`cat /net/vfiler-nfs03/vol/vol_DDBA_oracle_repo/qtr_repo/MDHA/dataguard_sync_check.sh | grep "export password=" | awk -F'=' '{print $2}'`
export sys_user_pass="sys/${sys_pass}"


#-------------------
# Files
#-------------------
export db_name_list_file=${script_tmpdir}/db_unique_name_list_file.txt
export db_processed_log=${script_logdir}/db_processed.log
export script_run_log=${script_logdir}/${script_basename}.log
export templog1=${script_tmpdir}/templog.1
export templog2=${script_tmpdir}/templog.2
export templog3=${script_tmpdir}/templog.3
> $templog1
> $templog2
> $templog3

exec > $script_run_log 2>> $script_run_log

echo INFO - Running script $script_name at `date`
echo INFO - Script base directory is $script_basedir

#-------------------
# CREATE DB LIST
#-------------------

echo "INFO - Creating list of databases from OEM repository in the file " $db_name_list_file

${ORACLE_HOME}/bin/sqlplus -s /nolog << EOF > $templog1 2>> $templog1
connect sys/$sys_pass@OEM12CP01 as sysdba

set pages 0
set lines 100
set head off
set feed off
set termout off

spool $db_name_list_file

--Debug-Force error for testing
--select x from y;

prompt
prompt INFO - DB UNIQUE NAMES
prompt

/*  Old code - gets prod and non-prod both
--prompt INFO- Non-RAC Databases
select a.target_name || ' NonRAC'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m
where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
--and   rownum < 3
order by 1;

--prompt INFO- RAC Databases
select target_name  || ' RAC'
from sysman.mgmt_targets where target_type='rac_database'
--and rownum < 7
order by 1;
*/

--prompt INFO- Prod Non-RAC Databases
--prompt
--select a.target_name || ' NonRAC Production'
--from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     --(select target_guid from sysman.mgmt_target_properties
        --where property_name='orcl_gtp_lifecycle_status' and property_value = 'Production') c
--where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
--and  a.target_guid = c.target_guid
--order by 1;

prompt INFO- Prod Non-RAC Databases with version
prompt
select a.target_name || ' NonRAC' || ' ' || c.property_value || ' ' || d.property_value
from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     (select target_guid, property_value from sysman.mgmt_target_properties
        where property_name='orcl_gtp_lifecycle_status' and property_value = 'Production') c,
     (select target_guid, property_value from sysman.mgmt_target_properties
        where property_name='DBVersion') d
where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
and  a.target_guid = c.target_guid
and  a.target_guid = d.target_guid
order by 1;

--prompt INFO- Prod RAC Databases
--prompt
--select a.target_name  || ' RAC Production'
--from sysman.mgmt_targets a, sysman.mgmt_target_properties m
--where a.target_type='rac_database'
  --and a.target_guid=m.target_guid
  --and m.property_name='orcl_gtp_lifecycle_status' and m.property_value = 'Production'
--order by 1;

prompt INFO- Prod RAC Databases with version
prompt
select a.target_name  || ' RAC' || ' ' || m.property_value || ' ' || d.property_value
from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     (select target_guid, property_value from sysman.mgmt_target_properties
        where property_name='DBVersion') d
where a.target_type='rac_database'
  and a.target_guid=m.target_guid
  and m.property_name='orcl_gtp_lifecycle_status' and m.property_value = 'Production'
  and a.target_guid=d.target_guid
order by 1;


--prompt INFO- Non-Prod Non-RAC Databases
--prompt
--select a.target_name || ' NonRAC Non-Production'
--from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     --(select target_guid from sysman.mgmt_target_properties
        --where property_name='orcl_gtp_lifecycle_status' and property_value != 'Production') c
--where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
--and  a.target_guid = c.target_guid
--order by 1;

prompt INFO- Non-Prod Non-RAC Databases with version
prompt
select a.target_name || ' NonRAC' || ' ' ||  c.property_value || ' ' || d.property_value
from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     (select target_guid, property_value from sysman.mgmt_target_properties
        where property_name='orcl_gtp_lifecycle_status' and property_value != 'Production') c,
     (select target_guid, property_value from sysman.mgmt_target_properties
        where property_name='DBVersion') d
where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
and  a.target_guid = c.target_guid
and  a.target_guid = d.target_guid
order by 1;

--prompt INFO- Non-Prod RAC Databases
--prompt
--select a.target_name  || ' RAC Non-Production'
--from sysman.mgmt_targets a, sysman.mgmt_target_properties m
--where a.target_type='rac_database'
  --and a.target_guid=m.target_guid
  --and m.property_name='orcl_gtp_lifecycle_status' and m.property_value != 'Production'
--order by 1;

prompt INFO- Non-Prod RAC Databases with version
prompt
select a.target_name  || ' RAC' || ' ' || m.property_value || ' ' || d.property_value
from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     (select target_guid, property_value from sysman.mgmt_target_properties
        where property_name='DBVersion') d
where a.target_type='rac_database'
  and a.target_guid=m.target_guid
  and m.property_name='orcl_gtp_lifecycle_status' and m.property_value != 'Production'
  and a.target_guid=d.target_guid
order by 1;



spool off

EOF

rc=$?
if [ $rc -ne 0 ] || ( grep "ORA-" $templog1 > /dev/null 2>> /dev/null ) || ( grep "SP2-" $templog1 > /dev/null 2>> /dev/null )
then

echo ERR - Failed to create master database list from OEM repository DB
echo ERR - See errors below
echo ERR - Correct errors and re-run
echo
#echo ERR - EXITING. VERIFY SQL SYNTAX, OEM REPO DB STATUS AND CONNECTIVITY AND TRY AGAIN.
echo ERR - *** NOT ***EXITING. VERIFY SQL SYNTAX, REPO DB STATUS AND CONNECTIVITY AND RUN UPLOAD SQL MANUALLY.
echo
cat ${templog1}
echo

#exit1

else

echo "INFO - Created list of databases from OEM repository"
echo

fi
