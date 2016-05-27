--
--
--

prompt Tablespaces (lists only for open PDBs)

select a.con_id, a.tablespace_name 
from cdb_tablespaces a, v$pdbs b
where a.con_id = b.con_id
order by 1, 2;

prompt Datafiles (lists only for open PDBs)

select a.con_id, b.name, a.tablespace_name, a.file_name 
from cdb_data_files a, v$pdbs b 
where a.con_id = b.con_id 
order by 1,2,3,4;

