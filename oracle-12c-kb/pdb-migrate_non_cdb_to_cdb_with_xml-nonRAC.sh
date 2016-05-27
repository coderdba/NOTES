#!/bin/ksh
#
# http://oracle-base.com/articles/12c/multitenant-migrate-non-cdb-to-pdb-12cr1.php
#
#

# Create description file from remote non-CDB DB
sqlplus sys/password@remote_db_tns as sysdba <<EOF

  SHUTDOWN IMMEDIATE;
  STARTUP OPEN READ ONLY;
  
  BEGIN
    DBMS_PDB.DESCRIBE(
      pdb_descr_file => '/tmp/db12c.xml');
  END;
  /

  SHUTDOWN IMMEDIATE;
  
EOF

# Create PDB in a CDB using the description file of remote DB
sqlplus / as sysdba <<EOF

  CREATE PLUGGABLE DATABASE pdb1 USING '/tmp/db12c.xml' COPY;
  -- The following may not be needed for ASM based DB's
  -- CREATE PLUGGABLE DATABASE pdb1 USING '/tmp/db12c.xml' COPY FILE_NAME_CONVERT = ('/u01/app/oracle/oradata/db12c/', '/u01/app/oracle/oradata/cdb1/pdb1/');
  
  ALTER SESSION SET CONTAINER=pdb1;
  @$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql
  
  ALTER SESSION SET CONTAINER=pdb1;
  ALTER PLUGGABLE DATABASE OPEN INSTANCES=ALL;
  
EOF


