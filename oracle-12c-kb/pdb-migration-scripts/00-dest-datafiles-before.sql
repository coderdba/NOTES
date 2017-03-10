set pages 1000
set lines 200

spool 00-datafiles-dest-before

select con_id || ' ' || tablespace_name || ' ' || file_name from cdb_data_files order by 1;

spool off
