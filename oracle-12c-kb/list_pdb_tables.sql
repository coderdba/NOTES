--
--
--

select a.con_id, b.name, a.owner, a.table_name, a.tablespace_name
from cdb_tables a, v$pdbs b
where a.con_id = b.con_id
and a.owner='USER1';
