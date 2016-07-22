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
where target_name in ('DB_UNIQUE_NAME1', 'DB_UNIQUE_NAME2')
)
and column_label = 'Used Space(GB)'
and metric_name = 'DATABASE_SIZE'
and rollup_timestamp > sysdate-90
order by 1, 2;

-- Based on http://www.nyoug.org/Presentations/2011/March/Iotzov_OEM_Repository.pdf
prompt
prompt 90 day old data
prompt
prompt This filters by rac_database and oracle_database for RAC and non-rac databases
prompt so that multiple instances of a DB are not listed repeatedly
prompt

select
a.target_name,
a.target_type,
a.metric_name,
a.metric_column,
a.rollup_timestamp,
a.average,
a.minimum,
a.maximum
from
mgmt$metric_daily a,
(select b.target_name, b.target_guid, min(b.rollup_timestamp) rollup_timestamp
   from mgmt$metric_daily b,
        mgmt$target_type c
  where b.rollup_timestamp >= sysdate-90
    and b.column_label = 'Used Space(GB)'
    and b.metric_name = 'DATABASE_SIZE'
    and (b.target_name like ('DB_UNIQUE_NAME_PATTERN%') or b.target_name like ('DB_UNIQUE_NAME'))
    and (b.target_type = 'rac_database' or (b.target_type = 'oracle_database' and c.type_qualifier3 != 'RACINST'))
    and b.metric_guid = c.metric_guid
    and b.target_guid = c.target_guid
  group by b.target_name, b.target_guid
) d
where
a.target_name = d.target_name
and a.target_guid = d.target_guid
and a.rollup_timestamp = d.rollup_timestamp
and a.metric_column in ('ALLOCATED_GB', 'USED_GB')
and a.metric_name = 'DATABASE_SIZE'
order by 1, 2;

spool off

