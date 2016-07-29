set pages 10000
set lines 100

column target_name format a20
column metric_name format a20
column average format 999990.9
column minimum format 999990.9
column maximum format 999990.9

spool spacetime

select a.target_name, a.rollup_timestamp, a.average, a.minimum, a.maximum
--metric_name,
from mgmt$metric_daily a,
     (select target_name, min(rollup_timestamp) rollup_timestamp
        from mgmt$metric_daily
       where  rollup_timestamp > to_date('15-JAN-14')-90
         and metric_name='DATABASE_SIZE'
         and target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
         )
      group by target_name
     ) b,
     (select target_name, max(rollup_timestamp) rollup_timestamp
        from mgmt$metric_daily
       where  rollup_timestamp > to_date('15-JAN-14')-90
         and  rollup_timestamp < to_date('15-JAN-14')
         and metric_name='DATABASE_SIZE'
         and target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
         )
      group by target_name
     ) c
where a.target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
)
and a.column_label = 'Used Space(GB)'
and a.metric_name = 'DATABASE_SIZE'
and ((a.target_name = b.target_name and a.rollup_timestamp = b.rollup_timestamp)
or (a.target_name = c.target_name and a.rollup_timestamp = c.rollup_timestamp))
order by 1, 2
;

-----------------------------
-----------------------------
-----------------------------
select a.target_name, a.rollup_timestamp, a.average, a.minimum, a.maximum
--metric_name,
from mgmt$metric_daily a,
     (select target_name, min(rollup_timestamp) rollup_timestamp
        from mgmt$metric_daily
       where  rollup_timestamp > to_date('15-JAN-14')-90
         and metric_name='DATABASE_SIZE'
         and target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
         )
      group by target_name
     ) b
/*
,
     (select target_name, max(rollup_timestamp) rollup_timestamp
        from mgmt$metric_daily
       where  rollup_timestamp > to_date('15-JAN-14')-90
         and  rollup_timestamp < to_date('15-JAN-14')
         and metric_name='DATABASE_SIZE'
         and target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
         )
      group by target_name
     ) c
*/
where a.target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
)
and a.column_label = 'Used Space(GB)'
and a.metric_name = 'DATABASE_SIZE'
and (a.target_name = b.target_name and a.rollup_timestamp = b.rollup_timestamp)
--and ((a.target_name = b.target_name and a.rollup_timestamp = b.rollup_timestamp)
--or (a.target_name = c.target_name and a.rollup_timestamp = c.rollup_timestamp))
order by 1, 2
;

select a.target_name, a.rollup_timestamp, a.average, a.minimum, a.maximum
--metric_name,
from mgmt$metric_daily a,
/*
     (select target_name, min(rollup_timestamp) rollup_timestamp
        from mgmt$metric_daily
       where  rollup_timestamp > to_date('15-JAN-14')-90
         and metric_name='DATABASE_SIZE'
         and target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
         )
      group by target_name
     ) b
,
*/
     (select target_name, max(rollup_timestamp) rollup_timestamp
        from mgmt$metric_daily
       where  rollup_timestamp > to_date('15-JAN-14')-90
         and  rollup_timestamp < to_date('15-JAN-14')
         and metric_name='DATABASE_SIZE'
         and target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
         )
      group by target_name
     ) c
where a.target_name in (
         'DB_UNIQUE_NAME1 or is it DB_NAME',
         'DB_UNIQUE_NAME1 or is it DB_NAME'
)
and a.column_label = 'Used Space(GB)'
and a.metric_name = 'DATABASE_SIZE'
--and ((a.target_name = b.target_name and a.rollup_timestamp = b.rollup_timestamp)
--or (a.target_name = c.target_name and a.rollup_timestamp = c.rollup_timestamp))
and (a.target_name = c.target_name and a.rollup_timestamp = c.rollup_timestamp)
order by 1, 2
;

spool off
