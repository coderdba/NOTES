-- Provide DB_NAME - not DB_UNIQUE_NAME
-- Lists db_name and db_unique_name's associated with it
-- NOTE: TARGET_TYPE = rac_database means the actual 'database' - not instance
--       TARGET_TYPE = oracle_database is the 'instance' - not database

select a.target_name db_unique_name, a.database_name db_name, b.target_name db_unique_name, b.target_type 
from  mgmt$db_dbninstanceinfo a,  mgmt$target b
where a.target_guid = b.target_guid 
and a.database_name= 'DB_NAME';

