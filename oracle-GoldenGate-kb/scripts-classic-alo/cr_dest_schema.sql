set echo on
set feed on

spool cr_dest_schema

create user oggdol identified by oggdol
default tablespace users temporary tablespace temp;
alter user oggdol quota unlimited on users;

grant create session, resource, create table to oggdol;

create table oggdol.table1
(empid number(5) primary key,
empname varchar2(20));

-- grant insert, update, delete on the destination tables to ogguserdl
grant select, insert, update, delete on oggdol.table1 to ogguserdl;

-- grant alter on the destination tables to ogguserdl (for DDL support)
grant alter on oggdol.table1 to ogguserdl;

spool off
