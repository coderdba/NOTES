--Based on http://www.nyoug.org/Presentations/2011/March/Iotzov_OEM_Repository.pdf

-- NOTE: Join with mgmt$target_type is necessary to filter RAC instances (not RAC DB which is db_unique_name) based on type_qualifier3

select
m.rollup_timestamp,
m.average
from
mgmt$metric_daily m ,
mgmt$target_type t
where
(t.target_type ='rac_database'
or (t.target_type ='oracle_database'
and t.type_qualifier3 != 'RACINST'))
and (m.target_guid = <GUID of the target database> OR m.target_name = 'db_unique_name')
and m.target_guid = t.target_guid
and m.metric_guid =t.metric_guid
and t.metric_name ='tbspAllocation'
and t.metric_column = 'spaceUsed'
and m.rollup_timestamp >= sysdate - 2
and m.rollup_timestamp <= sysdate
and m.key_value = p_tablespace_name;

