select rownum as " ", SERVICE_NAME,DATABASE_UNIQUE_NAME  ,ENABLED,PREFERRED_INSTANCES,AVAILABLE_INSTANCES,
RUNNING_INSTANCES,CLUSTER_NAME from
(select SERVICE_NAME,DATABASE_UNIQUE_NAME  ,ENABLED,PREFERRED_INSTANCES,AVAILABLE_INSTANCES,
RUNNING_INSTANCES,CLUSTER_NAME
 from cm$MGMT_RAC_SERVICES where service_type='user'
order by 1);


select distinct a.SERVICE_NAME,nvl(a.DATABASE_UNIQUE_NAME, b.database_name)  ,a.ENABLED,a.PREFERRED_INSTANCES,a.AVAILABLE_INSTANCES,
a.RUNNING_INSTANCES,CLUSTER_NAME, b.dbversion, b.creation_date, b.characterset from
(select SERVICE_NAME,DATABASE_UNIQUE_NAME  ,ENABLED,PREFERRED_INSTANCES,AVAILABLE_INSTANCES,
RUNNING_INSTANCES,CLUSTER_NAME
 from  cm$MGMT_RAC_SERVICES where service_type='user'
order by 1) a
left outer join cm$MGMT_DB_DBNINSTANCEINFO_ECM  b
on upper(substr(b.database_name, 1, (instr(b.database_name|| '_','_',1,1)-1))) = upper(substr(a.database_unique_name , 1, instr(a.database_unique_name|| '_', '_',1,1)-1));

select a.SERVICE_NAME,nvl(a.DATABASE_UNIQUE_NAME, b.database_name)  ,a.ENABLED,a.PREFERRED_INSTANCES,a.AVAILABLE_INSTANCES,
a.RUNNING_INSTANCES,CLUSTER_NAME, b.dbversion, b.creation_date, b.characterset,
listagg(b.host_name, ',') within group (order by a.database_unique_name) as host_names
from
(select SERVICE_NAME,DATABASE_UNIQUE_NAME  ,ENABLED,PREFERRED_INSTANCES,AVAILABLE_INSTANCES,
RUNNING_INSTANCES,CLUSTER_NAME
 from  cm$MGMT_RAC_SERVICES where service_type='user'
order by 1) a
left outer join cm$MGMT_DB_DBNINSTANCEINFO_ECM  b
on upper(substr(b.database_name, 1, (instr(b.database_name|| '_','_',1,1)-1))) = upper(substr(a.database_unique_name , 1, instr(a.database_unique_name|| '_', '_',1,1)-1))
where b.CM_TARGET_TYPE <> 'rac_database'
group by a.SERVICE_NAME,nvl(a.DATABASE_UNIQUE_NAME, b.database_name)  ,a.ENABLED,a.PREFERRED_INSTANCES,a.AVAILABLE_INSTANCES,
a.RUNNING_INSTANCES,CLUSTER_NAME, b.dbversion, b.creation_date, b.characterset;
