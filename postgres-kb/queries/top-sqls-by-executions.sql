SELECT
d.datname as db, 
r.rolname AS username, 
queryid, 
Substring(query, 1, 80)  AS query_partial,  
coalesce(calls, 0) as calls,  
total_exec_time AS total_exec_time, 
mean_exec_time AS mean_exec_time,  
coalesce(shared_blks_hit, 0) as shared_blks_hit,  
coalesce(shared_blks_read, 0) as shared_blks_read,  
coalesce(shared_blks_dirtied, 0) as shared_blks_dirtied, 
coalesce(shared_blks_written, 0) as shared_blks_written,  
coalesce(local_blks_hit, 0) as local_blks_hit,  
coalesce(local_blks_read, 0) as local_blks_read, 
coalesce(local_blks_dirtied, 0) as local_blks_dirtied, 
coalesce(local_blks_written, 0) as local_blks_written, 
coalesce(temp_blks_read, 0) as temp_blks_read, 
coalesce(temp_blks_written, 0) as temp_blks_written 
FROM pg_stat_statements,   pg_roles r,   pg_database d   
WHERE r.oid = userid  
AND   calls > 0 
AND d.oid = dbid 
ORDER BY calls DESC limit 20
