set pages 10000
set lines 100

column target_name format a20
column metric_name format a20
column average format 999990.9
column minimum format 999990.9
column maximum format 999990.9

spool spaceplatform


select count(*) DB_COUNT, sum(maximum) allocated_space_platform_gb
from
(
select distinct substr(target_name,1,12), rollup_timestamp, average, minimum, maximum
from mgmt$metric_daily
where
    column_label = 'Allocated Space(GB)'
and metric_name = 'DATABASE_SIZE'
and trunc(rollup_timestamp) = '08-FEB-2015'
)
;

select count(*) DB_COUNT, sum(maximum) used_space_platform_gb
from
(
select distinct substr(target_name,1,12), rollup_timestamp, average, minimum, maximum
from mgmt$metric_daily
where
    column_label = 'Used Space(GB)'
and metric_name = 'DATABASE_SIZE'
and trunc(rollup_timestamp) = '08-FEB-2015'
)
;

select distinct substr(target_name,1,12), rollup_timestamp, average, minimum, maximum
from mgmt$metric_daily
where
    column_label = 'Allocated Space(GB)'
and metric_name = 'DATABASE_SIZE'
and trunc(rollup_timestamp) = '08-FEB-2015'
order by 1;


select distinct substr(target_name,1,12), rollup_timestamp, average, minimum, maximum
from mgmt$metric_daily
where
    column_label = 'Used Space(GB)'
and metric_name = 'DATABASE_SIZE'
and trunc(rollup_timestamp) = '08-FEB-2015'
order by 1;

spool off
