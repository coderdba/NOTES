---
--- NOTE - classify target groups by rac/non-rac, os etc by joining with mgmt$target_properties
--

a.AVAILABILITY_STATUS, count(*)
from  mgmt$availability_current a,
      mgmt$target b
where a.target_type = 'oracle_listener'
and   a.target_name = b.target_name
and   a.target_guid = b.target_guid
--and   availability_status != 'Target Up'
and   b.host_name in
(select host_name
   from mgmt$target
  where target_name like '%RACP%'
    and target_type = 'oracle_database'
)
group by 'RAC PROD LISTENER', a.AVAILABILITY_STATUS
order by a.AVAILABILITY_STATUS;
