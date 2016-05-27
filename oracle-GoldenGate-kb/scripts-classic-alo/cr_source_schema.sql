set echo on
set feed on
spool cr_source_schema

create user oggsol identified by oggsol
default tablespace users temporary tablespace temp;
alter user oggsol quota unlimited on users;

grant create session, resource, create table to oggsol;

create table oggsol.table1
(empid number(5) primary key,
 empname varchar2(20));

grant flashback on oggsol.table1 to oggusersl;
grant select on oggsol.table1 to oggusersl;

spool off
