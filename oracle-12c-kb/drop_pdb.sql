--
--
--

-- Close the clone PDB.
alter pluggable database pdb1 close immediate instances=all;

-- Delete the PDB and its data files
drop pluggable database pdb1 including datafiles;
