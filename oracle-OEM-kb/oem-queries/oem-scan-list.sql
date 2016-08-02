set pages 1000
set feed on

spool scan_list

select c.target_name || ' ' || b.property_value
from sysman.mgmt_target_properties b, sysman.mgmt_targets c
where c.target_guid=b.target_guid
and b.property_name= 'scanName';

select c.target_name || ' ' || b.property_value
from sysman.mgmt_target_properties b, sysman.mgmt_targets c
where c.target_guid=b.target_guid
and b.property_name= 'scanPort';

spool off
