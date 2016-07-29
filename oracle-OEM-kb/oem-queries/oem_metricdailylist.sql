set lines 120
set pages 200

column target_name format a10
column metric_name format a40
column column_label format a60

spool  metricdailylist

select distinct target_name, metric_name, column_label
from mgmt$metric_daily
where target_name = 'MY_DB_NAME'
and rollup_timestamp > sysdate-2 and rollup_timestamp < sysdate-1
order by 1, 2, 3;

spool off
