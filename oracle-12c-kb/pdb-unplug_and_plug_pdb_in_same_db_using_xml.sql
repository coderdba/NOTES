--
-- http://www.dummies.com/how-to/content/how-to-unplug-and-plug-in-your-pluggable-database-.html
-- http://oracle-base.com/articles/12c/multitenant-create-and-configure-pluggable-database-12cr1.php#manual-unplug-pdb
--

-- Close the PDB on all instances
alter pluggable database pdb1 close immediate instances=all;

-- Unplug the PDB - sends metadata to an xml file
alter pluggable database pdb1 UNPLUG INTO '/oracle/dumps/pdb1-unplug.xml';

-- Drop the PDB with 'keep datafiles' to retain data to plug-in again
drop pluggable database pdb1 keep datafiles;

-- Check PDB's compatibility with the CDB version
connect / as sysdba
SET SERVEROUTPUT ON
DECLARE
 compatible CONSTANT VARCHAR2(3) :=
  CASE DBMS_PDB.CHECK_PLUG_COMPATIBILITY(
      pdb_descr_file => '/oracle/dumps/pdb1-unplug.xml')
  WHEN TRUE THEN 'YES'
  ELSE 'NO'
END;
BEGIN
 DBMS_OUTPUT.PUT_LINE(compatible);
END;
/

-- Plug-in the PDB back into the DB
create pluggable database pdb1 
using '/oracle/dumps/pdb1-unplug.xml' 
nocopy tempfile reuse;

-- List PDBs and their open state
show pdbs

-- 
alter pluggable database pdb1 open instances=all;
