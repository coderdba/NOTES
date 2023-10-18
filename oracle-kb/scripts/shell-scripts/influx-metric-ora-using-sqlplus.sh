export PATH=$PATH:/root/oracle/instantclient_21_11
export LD_LIBRARY_PATH=/root/oracle/instantclient_21_11

# Influx format
# myMeasurement,tag1=value1,tag2=value2 fieldKey="fieldValue" 1556813561098000000

sqlplus -s /nolog <<EOF

set head off
set feed off
set echo off

connect sremon/$SREMON_PASSWORD@192.168.29.197:1521/XEPDB1

select sysdate from dual;

select (cast (systimestamp at time zone 'UTC' as date) - date '1970-01-01') * 86400 from dual;

select 
'autotron_oradb_up'||','||
'instance_name=' || a.instance_name || ' ' || 1 || ' ' || 
(cast (systimestamp at time zone 'UTC' as date) - date '1970-01-01') * 86400 
from v\$instance a; 

EOF

