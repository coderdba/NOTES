--
--
--

column name format a50
set lines 100
set pages 50

prompt PDB Modifiable or Not
select distinct ispdb_modifiable, name 
from v$system_parameter 
order by 1,2;

prompt Session Modifiable or Not
select distinct isses_modifiable, ispdb_modifiable, name 
from v$system_parameter 
order by 1,3,2;

prompt System Modifiable or Not
select distinct issys_modifiable, ispdb_modifiable, name 
from v$system_parameter 
order by 1,3,2;

prompt All types
select distinct name, isses_modifiable, issys_modifiable, ispdb_modifiable
from v$system_parameter 
order by 1;
