-- Based on https://oraclequest.wordpress.com/2013/01/08/extracting-data-from-oem-12c-repository-for-database-capacity-planning/

set pages 10000
set lines 100

column target_name format a20
column metric_name format a20
column average format 999990.9
column minimum format 999990.9
column maximum format 999990.9

spool space

-- 1. find target name
--select target_name from mgmt_targets
--where target_type='rac_database';

--Use target_type='oracle_database' if the target is non-rac database.

-- 2. find good metric
--select * from mgmt$metric_daily
--where target_name = <target_name from="" query="" 1="">
--and trunc(rollup_timestamp) = trunc(sysdate)-1;

-- 3. get metric history

select target_name,
--metric_name,
rollup_timestamp, average, minimum, maximum
from mgmt$metric_daily
--where target_name = <target_name from="" query="" 1="">
where target_name in (
'DB_UNIQUE_NAME1', 'DB_UNIQUE_NAME2'...
)
and column_label = 'Used Space(GB)'
and metric_name = 'DATABASE_SIZE'
and rollup_timestamp > sysdate-90
order by 1, 2;


prompt
prompt  90 day old data
prompt

select target_name,
--metric_name,
min(rollup_timestamp), average, minimum, maximum
from mgmt$metric_daily
--where target_name = <target_name from="" query="" 1="">
where target_name in (
'DB_UNIQUE_NAME1', 'DB_UNIQUE_NAME2'...
)
and column_label = 'Used Space(GB)'
and metric_name = 'DATABASE_SIZE'
and rollup_timestamp > sysdate-90
group by target_name
order by 1, 2;

spool off

