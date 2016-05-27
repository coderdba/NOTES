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
# Set up remote PDB
# Connect to remote DB and create a user for DB-Link from local DB
#-----
echo "INFO - Settign up remote DB"
sqlplus sys/password@remote_db <EOF

  ALTER SESSION SET CONTAINER=pdb1;
  CREATE USER remote_clone_user IDENTIFIED BY password;
  GRANT CREATE SESSION, CREATE PLUGGABLE DATABASE TO remote_clone_user;
  
  ALTER PLUGGABLE DATABASE pdb1 CLOSE instances=all;
  ALTER PLUGGABLE DATABASE pdb1 OPEN READ ONLY instances=all;

EOF

#-----
# Clone into local database as a cloned PDB
# Connect to local DB and run create PDB using DB-Link
#-----
echo "INFO - Cloning into local DB"
sqlplus / as sysdba <<EOF

  DROP DATABASE LINK clone_link;
  CREATE DATABASE LINK clone_link CONNECT TO remote_clone_user IDENTIFIED BY remote_clone_user USING 'pdb1_remote_tnsEntry';
  
  CREATE PLUGGABLE DATABASE pdb1 FROM pdb1@clone_link;
  
  ALTER PLUGGABLE DATABASE PDB1 OPEN INSTANCES=ALL;

EOF
