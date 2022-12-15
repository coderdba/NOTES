Version 13:

SELECT
d.datname as db, 
r.rolname AS username, 
queryid, Substring(query, 1, 80)  AS query_partial,  
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
AND   mean_exec_time > 0 AND d.oid = dbid 
ORDER BY mean_exec_time DESC limit 20

Version 11:

SELECT 
d.datname as DbName,
r.rolname AS UserName,
Round((100 * total_time / Sum(total_time::numeric) OVER ())::numeric, 2) AS CpuPercent,
coalesce(calls, 0) AS Calls,
Round(total_time::numeric, 2) AS TotalTime,
Round(mean_time::numeric, 2) AS MeanTime,
coalesce(shared_blks_hit, 0) AS SharedBlksHit,
coalesce(shared_blks_read, 0) AS SharedBlksRead,
coalesce(shared_blks_read, 0) AS SharedBlksWritten,
coalesce(local_blks_hit, 0) AS LocalBlksHit,
coalesce(local_blks_read, 0) AS LocalBlksRead,
coalesce(local_blks_read, 0) AS LocalBlksWritten,
Substring(query, 1, 800)     AS PartialQuery
FROM pg_stat_statements,pg_roles r,pg_database d
WHERE r.oid = userid
AND d.oid = dbid
ORDER BY mean_time DESC limit 20
