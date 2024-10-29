
SELECT sc.name as schema_name, p.name as sp_name, st.last_execution_time, st.execution_count
FROM sys.procedures AS p 
INNER JOIN sys.schemas AS sc
ON p.[schema_id] = sc.[schema_id]LEFT OUTER JOIN sys.dm_exec_procedure_stats AS st ON p.[object_id] = st.[object_id] 
ORDER BY sc.name asc, st.last_execution_time desc, p.name asc

select distinct sc.name as schema_name, p.name as sp_name
from sys.procedures p,
     sys.schemas sc,
	 sys.dm_exec_procedure_stats st
where p.schema_id = sc.schema_id
and   st.object_id = p.object_id
--and   st.last_execution_time = NULL;
order by 1,2
