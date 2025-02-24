-- Name: Long running SQLs 
-- Level: server
-- Explanation: Gives the SQL statements that have been running for longer than 15 minutes.
-- Suggestion: "It may be abnormal that these SQLs are running that long. Check why and tune them or reduce amount of data they process so that they complete faster."
SELECT 
DB_NAME(r.database_id) AS [Database Name], 
r.session_id AS [Session ID],  
r.status AS [Status],  
r.wait_type AS [Wait Type],  
r.wait_time AS [Wait Time (ms)],  
r.cpu_time AS [CPU Time (ms)],  
r.total_elapsed_time AS [Elapsed Time (ms)],  
st.text AS [SQL Statement]  
FROM sys.dm_exec_requests AS r  
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st  
WHERE r.status NOT IN ('background', 'sleeping')  
AND r.total_elapsed_time > 900000 -- 15 minutes  
ORDER BY r.total_elapsed_time DESC
