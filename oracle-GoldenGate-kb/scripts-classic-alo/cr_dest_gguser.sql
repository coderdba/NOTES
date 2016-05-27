set echo on
set feed on

spool cr_dest_gguser

create user ogguserdl identified by ogguserdl
default tablespace goldengatel temporary tablespace temp;

grant create session to ogguserdl;
grant connect to ogguserdl;
grant resource to ogguserdl;
EXEC DBMS_GOLDENGATE_AUTH.GRANT_ADMIN_PRIVILEGE('OGGUSERDL');
grant select any dictionary to ogguserdl;
grant create table to ogguserdl;
grant select any table to ogguserdl;

--insert, update, delete on target tables -- do separately
--alter on target tables -- do separately
-- grant lock any table to ogguserdl; -- required only if bulk-loading using sql-loader intially


-- Old from integrated POC
-- create user ogguserdl identified by ogguserdl
-- default tablespace users temporary tablespace temp;
--
-- grant create session, alter session to ogguserdl;
-- grant resource to ogguserdl;
-- grant select any dictionary to ogguserdl;
--
-- alter user ogguserdl quota unlimited on users;
-- EXEC DBMS_GOLDENGATE_AUTH.GRANT_ADMIN_PRIVILEGE('OGGUSERDC');
--
-- grant create table to ogguserdl;

spool off
