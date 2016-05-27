#!/bin/ksh
#
# http://docs.oracle.com/database/121/ADMIN/cdb_plug.htm#ADMIN13593
# see section Cloning a Remote PDB or Non-CDB
#
# http://www.oracle.com/webfolder/technetwork/tutorials/obe/db/12c/r1/pdb/pdb_clone/pdb_clone.html
# http://oracle-base.com/articles/12c/multitenant-clone-remote-pdb-or-non-cdb-12cr1.php
#
#

#-----
# Set up remote DB
# Connect to remote DB and create a user for DB-Link from local DB
#-----
echo "INFO - Settign up remote DB"
sqlplus sys/password@remote_db <EOF

  CREATE USER remote_clone_user IDENTIFIED BY remote_clone_user;
  GRANT CREATE SESSION, CREATE PLUGGABLE DATABASE TO remote_clone_user;
    
  SHUTDOWN IMMEDIATE;
  STARTUP MOUNT;
  ALTER DATABASE OPEN READ ONLY;
  EXIT;

EOF

#-----
# Clone into local database as a cloned PDB
# Connect to local DB and run create PDB using DB-Link
#-----
echo "INFO - Cloning into local DB"
sqlplus / as sysdba <<EOF
  DROP DATABASE LINK clone_link;
  CREATE DATABASE LINK clone_link CONNECT TO remote_clone_user IDENTIFIED BY remote_clone_user USING 'remoteDB_tnsEntry';
  CREATE PLUGGABLE DATABASE pdb1 FROM NON$PDB@clone_link; --NON$PDB is a dummy name
  
  ALTER SESSION SET CONTAINER=pdb1;
  @$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql
  
  ALTER PLUGGABLE DATABASE pdb1 OPEN INSTANCES=ALL;
  
EOF
