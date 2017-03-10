set pages 1000
set lines 200

spool 07-dest-datafiles-after

select con_id || ' ' || tablespace_name || ' ' || file_name from cdb_data_files order by 1;
