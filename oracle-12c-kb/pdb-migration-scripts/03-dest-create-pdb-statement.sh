#!/bin/ksh -x

export ORACLE_SID=TEST11
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2
export LD_LIBRARY_PATH=/u01/app/oracle/product/12.1.0.2/lib
export PATH=/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:/home/oracle/bin:/u01/app/oracle/product/12.1.0.2/bin:/usr/bin/X11:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:.

sqlplus -s '/ as sysdba' <<EOF

set timing on
set time on

select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

-- This worked
--CREATE PLUGGABLE DATABASE NONCDBPDB USING '/home/oracle/pdbwork/pdb-convert/PDB1.xml' NOCOPY TEMPFILE reuse;

-- This worked
--CREATE PLUGGABLE DATABASE NONCDBPDB USING '/home/oracle/pdbwork/pdb-convert/PDB1.xml' COPY TEMPFILE reuse ;

-- This works - with DB_CREATE_FILE_DEST init parameter set in the destination database
--CREATE PLUGGABLE DATABASE NONCDBPDB USING '/home/oracle/pdbwork/pdb-convert/PDB1.xml' MOVE TEMPFILE reuse ;

-- This works
CREATE PLUGGABLE DATABASE NONCDBPDB USING '/home/oracle/pdbwork/pdb-convert/PDB1.xml' MOVE TEMPFILE reuse
FILE_NAME_CONVERT=('+DATA_DG01','+DATA_DG01','+FRA_DG01','+FRA_DG01');

-- WHAT ARE THESE?
--CREATE PLUGGABLE DATABASE NONCDBPDB USING '/home/oracle/pdbwork/pdb-convert/PDB1.xml' NOCOPY TEMPFILE reuse FILE_NAME_CONVERT = ('+DATA_DG01/rl6db2_ttc/datafile/', '+DATA_DG01');

--CREATE PLUGGABLE DATABASE NONCDBPDB USING '/home/oracle/pdbwork/pdb-convert/PDB1.xml' NOCOPY TEMPFILE reuse SOURCE_FILE_NAME_CONVERT = ('+DATA_DG01/rl6db2_ttc/datafile/', '+DATA_DG01');


select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

EOF
