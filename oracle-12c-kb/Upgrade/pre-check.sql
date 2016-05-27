--
-- 12c_upgrade_precheck.sql
--

-- Check duplicate objects between SYS and SYSTEM
prompt
prompt Check duplicate objects between SYS and SYSTEM
prompt
select OBJECT_NAME, OBJECT_TYPE from
DBA_OBJECTS where OBJECT_NAME||OBJECT_TYPE
in (select OBJECT_NAME||OBJECT_TYPE from
DBA_OBJECTS where OWNER='SYS') and
OWNER='SYSTEM' and OBJECT_NAME not in
('AQ$_SCHEDULES_PRIMARY', 'AQ$_SCHEDULES',
'DBMS_REPCAT_AUTH');


-- Check invalid objects
prompt
prompt Checking invalid objects in SYS and SYSTEM users
prompt
select substr(owner,1,6) owner, substr(object_name,1,30) object, substr(object_type,1,30)
type, status, LAST_DDL_TIME from dba_objects where status <>'VALID' and owner like 'SYS%';

-- Note that the argument to the sql is the current working directory to store the log file
@$ORACLE_HOME/rdbms/admin/dbupgdiag.sql ./

-- Run the repair sql
@$ORACLE_HOME/rdbms/admin/utlrp.sql ./

-- Run pre-upgrade check script from 12c home
@/u01/app/oracle/product/12.1.0.2.RAC/rdbms/admin/preupgrd.sql
