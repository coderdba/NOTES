-- Name: Database Blocking Info
-- Level: DB
-- Explanation: Blocking sessions. They can result in long waits for sessions that need the blocked resources.
-- Suggestion: Kill the blocking sessions if necessary and WITH CAUTION. Investigate further if blockers are too frequent or too long.

SELECT 
session_id as [Session Id], 
command as [Command], 
blocking_session_id as [Blocking Session Id],
wait_type as [Wait Type], 
wait_time as[Wait Time], 
wait_resource as [Wait Resource], 
t.TEXT as [Text] 
FROM sys.dm_exec_requests 
CROSS apply sys.dm_exec_sql_text(sql_handle) AS t 
WHERE session_id > 50 AND blocking_session_id >	 0 
UNION 
SELECT session_id, '', '', '', '', '', t.TEXT 
FROM sys.dm_exec_connections 
CROSS apply sys.dm_exec_sql_text(most_recent_sql_handle) AS t 
WHERE session_id IN (SELECT blocking_session_id 
FROM sys.dm_exec_requests 
WHERE blocking_session_id > 0)
