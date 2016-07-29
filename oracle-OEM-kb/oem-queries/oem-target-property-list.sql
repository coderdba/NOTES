-- SQL> desc  mgmt$target_properties;
--  Name                                                  Null?    Type
--  ----------------------------------------------------- -------- ------------------------------------
--  TARGET_NAME                                           NOT NULL VARCHAR2(256)
--  TARGET_TYPE                                           NOT NULL VARCHAR2(64)
--  TARGET_GUID                                           NOT NULL RAW(16)
--  PROPERTY_NAME                                         NOT NULL VARCHAR2(64)
--  PROPERTY_VALUE                                                 VARCHAR2(1024)
--  PROPERTY_TYPE                                         NOT NULL VARCHAR2(64)
--

set lines 150
set pages 2000

column target_type   format a25
column property_type format a25
column property_name format a30

spool targetpropertieslist

select distinct target_type, property_type, property_name
from mgmt$target_properties
order by 1,2,3;

spool off
