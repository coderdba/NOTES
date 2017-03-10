sqlplus -s '/ as sysdba' <<EOF

set timing on
set time on

select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

--ALTER SESSION set container=PDB1;
ALTER SESSION set container=NONCDBPDB;

@$ORACLE_HOME/rdbms/admin/noncdb_to_pdb.sql

select to_char(sysdate, 'DD-MON-YYYY HH24:MI:SS') from dual;

EOF
