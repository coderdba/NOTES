--prompt INFO- Prod Non-RAC Databases
select a.target_name || ' NonRAC Production'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     (select target_guid from sysman.mgmt_target_properties
        where property_name='orcl_gtp_lifecycle_status' and property_value = 'PROD') c
where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
and  a.target_guid = c.target_guid
order by 1;

--prompt INFO- Prod RAC Databases
select a.target_name  || ' RAC Production'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m
where a.target_type='rac_database'
  and a.target_guid=m.target_guid
  and m.property_name='orcl_gtp_lifecycle_status' and m.property_value = 'PROD'
order by 1;

--prompt INFO- Non-Prod Non-RAC Databases
select a.target_name || ' NonRAC Production'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m
     (select target_guid from sysman.mgmt_target_properties
        where property_name='orcl_gtp_lifecycle_status' and property_value != 'PROD') c
where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
and  a.target_guid = c.target_guid
order by 1;

--prompt INFO- Non-Prod RAC Databases
select a.target_name  || ' RAC Production'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m
where a.target_type='rac_database'
  and a.target_guid=m.target_guid
  and m.property_name='orcl_gtp_lifecycle_status' and m.property_value != 'PROD'
order by 1;
