--
-- DB_UNIQUE_NAMEs and INSTANCES
-- TARGET_TYPE rac_database means DB_UNIQUE_NAME of RAC DB
-- TARGET_TYPE oracle_database means instance of RAC DB in the format DB_UNIQUE_NAME_<instance name>
--                                   - OR - the SID of the non-rac database
--
-- For rac_database target-type, 'host_name' will be one of the hosts of the multiple instances
-- For oracle_databast target-type, 'host_name' will  be the host for that instance - MORE RELIABLE FOR GETTING HOST NAMES
--

-- note: This query does not really relate a DB with its instance - just dumps data for those target types
select  TARGET_TYPE, TARGET_NAME, HOST_NAME from mgmt$target where TARGET_TYPE in ( 'oracle_database', 'rac_database')
order by 2,1;

-- Provide DB_NAME - not DB_UNIQUE_NAME
-- Lists db_name and db_unique_name's associated with it
-- NOTE: TARGET_TYPE = rac_database means the actual 'database' DB_UNIQUE_NAME - not instance
--       TARGET_TYPE = oracle_database is the 'instance' - not database

select a.target_name db_unique_name, a.database_name db_name, b.target_name db_unique_name, 
       b.target_type, trim(a.host_name), a.instance_name, a.creation_date
from  mgmt$db_dbninstanceinfo a,  mgmt$target b
where a.target_guid = b.target_guid 
and a.database_name= 'DB_NAME';


/* REFERENCE SYSMAN OBJECTS
SQL> desc mgmt$db_dbninstanceinfo
 Name                                      Null?    Type
 ----------------------------------------- -------- ----------------------------
 HOST_NAME                                          VARCHAR2(256)
 TARGET_NAME                               NOT NULL VARCHAR2(256)
 TARGET_TYPE                               NOT NULL VARCHAR2(64)
 TARGET_GUID                                        RAW(16)
 COLLECTION_TIMESTAMP                      NOT NULL DATE
 DATABASE_NAME                                      VARCHAR2(9)
 GLOBAL_NAME                                        VARCHAR2(4000)
 BANNER                                             VARCHAR2(80)
 HOST                                               VARCHAR2(64)
 INSTANCE_NAME                                      VARCHAR2(16)
 STARTUP_TIME                                       DATE
 LOGINS                                             VARCHAR2(10)
 LOG_MODE                                           VARCHAR2(12)
 OPEN_MODE                                          VARCHAR2(10)
 DEFAULT_TEMP_TABLESPACE                            VARCHAR2(30)
 CHARACTERSET                                       VARCHAR2(64)
 NATIONAL_CHARACTERSET                              VARCHAR2(64)
 DV_STATUS_CODE                                     NUMBER(1)
 CREATION_DATE                                      DATE
 RELEASE                                            VARCHAR2(64)
 EDITION                                            VARCHAR2(64)
 DBVERSION                                          VARCHAR2(20)
 IS_64BIT                                           VARCHAR2(1)
 REL_STATUS                                         VARCHAR2(64)
 SUPPLEMENTAL_LOG_DATA_MIN                          VARCHAR2(8)

*/

