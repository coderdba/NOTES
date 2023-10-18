#
#
#
#
#
#
#

export PATH=$PATH:/root/oracle/instantclient_21_11
export LD_LIBRARY_PATH=/root/oracle/instantclient_21_11

this_script=$0
this_script_basename=`basename $this_script`
outfile=/tmp/${this_script_basename}.out
current_unix_epoch_sec=`date '+%s'`
#current_unix_epoch_ms=`date '+%s'`

# Influx format
# myMeasurement,tag1=value1,tag2=value2 fieldKey="fieldValue" 1556813561098000000


sqlplus -s /nolog <<EOF > $outfile 2>> $outfile

set head off
set feed off
set echo off
set lines 200

connect sremon/$SREMON_PASSWORD@192.168.29.197:1521/XEPDB1

--select sysdate from dual;
--select (cast (systimestamp at time zone 'UTC' as date) - date '1970-01-01') * 86400 from dual;

--select 
--'autotron_oradb'||','||
--'instance_name=' || instance_name || ' up=' || 1 || ' ' || 
--(cast (systimestamp at time zone 'UTC' as date) - date '1970-01-01') * 86400000
--from v\$instance; 

--select 
--'autotron_oradb'||','||
--'username=' || username || ',' ||
--'account_status=' || account_status || ' account_status_found=' || 1 || ',' ||
----'expiry_date_epoch_sec=' || (cast (expiry_date at time zone 'UTC' as date) - date '1970-01-01') * 86400 || ' ' ||
--(cast (systimestamp at time zone 'UTC' as date) - date '1970-01-01') * 86400000
--from dba_users
--where username = 'SREMON' or username like 'AUTOTRON%';


select
'autotron_oradb'||','||
'instance_name=' || instance_name || ',' || 
'active_state=' || active_state || ',' || 'blocked=' || blocked || ' up=' || 1
from v\$instance;

select 
'autotron_oradb'||','||
'username=' || username || ',' ||
'account_status=' || account_status || ' account_status_found=' || 1 
|| ',' ||
'expiry_date_epoch_sec=' || (expiry_date - date '1970-01-01') * 86400 
from dba_users
where username = 'SREMON' or username like 'AUTOTRON%';


EOF

if (grep ORA- $outfile > /dev/null 2>> /dev/null)
then

  #echo autotron_oradb,instance_name=xe up=0 $current_unix_epoch_sec
  #echo autotron_oradb,username=collection_error account_status_found=1 $current_unix_epoch_sec

  echo autotron_oradb,instance_name=xe up=0
  echo autotron_oradb,username=collection_error account_status_found=1 

else

  cat $outfile

fi

