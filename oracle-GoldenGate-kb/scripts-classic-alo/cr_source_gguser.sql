set echo on
set feed on
spool cr_source_gguser

-- GG user should have its own tablespace in destination to support marker, ddl etc
create user oggusersl identified by oggusersl
default tablespace goldengatel temporary tablespace temp;

grant create session to oggusersl;
grant connect to oggusersl;
grant resource to oggusersl;
--grant alter any table --give this at individual table level
grant alter system to oggusersl;
EXEC DBMS_GOLDENGATE_AUTH.GRANT_ADMIN_PRIVILEGE('OGGUSERSL');
grant select any dictionary to oggusersl;
grant select any transaction to oggusersl;
grant select any table to oggusersl;

--grant dba to oggusersl; -- see if it is really required
--grant execute on sys.dbms_internal_clkm -- for TDE

-- Old - from integrated POC --
--grant create session, alter session to oggusersl;
--grant resource to oggusersl;
--grant select any dictionary to oggusersl;

--grant flashback any table to oggusersl;
--grant select any table to oggusersl;

--grant create table to oggusersl;
--grant execute on dbms_flashback to oggusersl;

--EXEC DBMS_GOLDENGATE_AUTH.GRANT_ADMIN_PRIVILEGE('OGGUSERSC');

--alter user oggusersl quota unlimited on users;

spool off
