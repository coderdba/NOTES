select name,db_unique_name,database_role from v$database;
select THREAD#,SEQUENCE#,ARCHIVED,APPLIED,STATUS from v$archived_log order by 1,2;
