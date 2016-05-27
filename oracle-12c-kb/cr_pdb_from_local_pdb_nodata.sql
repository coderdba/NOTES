 --
 --
 --

-- Prepare source PDB to provide consistent data by open-read-only
alter pluggable database pdb1 close immediate instances=all;
alter pluggable database pdb1 open read only instances=all;

-- Clone the PDB
CREATE PLUGGABLE DATABASE pdb2 FROM pdb1 NO DATA;
alter pluggable database pdb2 open instances=all;

-- Re-open source pdb in read-write mode
alter pluggable database pdb1 close immediate instances=all;
alter pluggable database pdb1 open instances=all;

-- Verify
select con_id, name, open_mode from v$pdbs order by 1,2;

