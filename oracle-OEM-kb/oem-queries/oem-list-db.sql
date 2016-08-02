-- LISTING DB UNIQUE NAMES

prompt ===========================================
prompt LISTING DB UNIQUE NAMES
prompt ===========================================
prompt INFO- Prod Non-RAC Databases (DB UNIQUE NAMES)
select a.target_name || ' NonRAC Production'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     (select target_guid from sysman.mgmt_target_properties
        where property_name='orcl_gtp_lifecycle_status' and property_value = 'PROD') c
where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
and  a.target_guid = c.target_guid
order by 1;

prompt INFO- Prod Non-RAC Databases with version
prompt
select a.target_name || ' NonRAC Production', c.property_value, d.property_value
from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     (select target_guid, property_value from sysman.mgmt_target_properties
        where property_name='orcl_gtp_lifecycle_status' and property_value = 'PROD') c,
     (select target_guid, property_value from sysman.mgmt_target_properties
        where property_name='DBVersion') d
where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
and  a.target_guid = c.target_guid
and  a.target_guid = d.target_guid
order by 1;

prompt INFO- Prod RAC Databases (DB UNIQUE NAMES)
select a.target_name  || ' RAC Production'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m
where a.target_type='rac_database'
  and a.target_guid=m.target_guid
  and m.property_name='orcl_gtp_lifecycle_status' and m.property_value = 'PROD'
order by 1;

prompt INFO- Non-Prod Non-RAC Databases (DB UNIQUE NAMES)
select a.target_name || ' NonRAC Production'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m,
     (select target_guid from sysman.mgmt_target_properties
        where property_name='orcl_gtp_lifecycle_status' and property_value != 'Production') c
where a.TARGET_TYPE='oracle_database' and a.TARGET_GUID=m.TARGET_GUID and m.PROPERTY_NAME='RACOption' and m.PROPERTY_VALUE='NO'
and  a.target_guid = c.target_guid
order by 1;

prompt INFO- Non-Prod RAC Databases (DB UNIQUE NAMES)
select a.target_name  || ' RAC Production'
from sysman.mgmt_targets a, sysman.mgmt_target_properties m
where a.target_type='rac_database'
  and a.target_guid=m.target_guid
  and m.property_name='orcl_gtp_lifecycle_status' and m.property_value != 'PROD'
order by 1;

--=================================
--ALTERNATE QUERY
-- NOT GUARANTEED
--=================================

set pages 1000
set lines 80

column prod_non_prod format a20
column database_name format a20

spool db_list_lifecyclewise

select distinct p.property_value prod_non_prod, a.database_name
from  mgmt$db_dbninstanceinfo a,  mgmt$target t, mgmt$target_properties p, mgmt$all_target_prop_defs d
where a.target_guid = t.target_guid
       --and a.database_name= 'DB_NAME'
       and t.target_guid=p.target_guid
       and p.property_name=d.property_name
       --and p.property_value = 'Production'
       and d.property_display_name = 'LifeCycle Status'
order by 1,2
;

spool off

