-- Name: Blockers and Waiters
-- Level: Server
-- Note:
-- explanation: This SQL query identifies current blockers and waiters in SQL Server.
-- suggestion: Analyze why sessions are blocking, maybe due to long running nature of queries run by those sessions. Tune queries or reduce amount of workload to reduce blocking
    
SELECT  
  DB_NAME(er.database_id) AS [Database], 
  er.blocking_session_id AS [Blocker ID],  
  er.wait_type AS [Wait Type],  
  er.wait_time as [Wait Time],  
  er.wait_resource as [Wait Resources], 
  er.session_id AS [Waiter ID],  
  es.host_name as [Host Name],  
  es.program_name as [Program Name],  
  es.login_name as [Login Name],  
  es.login_time AS [Start Time], 
  es.status as [Status]  
  FROM  sys.dm_exec_requests er 
  JOIN  sys.dm_exec_sessions es ON  er.session_id = es.session_id 
  WHERE er.blocking_session_id <> 0




