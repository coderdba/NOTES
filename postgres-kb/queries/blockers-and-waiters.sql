-- https://stackoverflow.com/questions/26489244/how-to-detect-query-which-holds-the-lock-in-postgres

-- Gives blocked query (not blocker as well)
SELECT bl.pid     AS blocked_pid,
     a.usename  AS blocked_user,
     a.query    AS blocked_statement
FROM  pg_catalog.pg_locks         bl
 JOIN pg_catalog.pg_stat_activity a  ON a.pid = bl.pid
WHERE NOT bl.granted;

-- Gives just the pid of the blocker, and query of the waiter
-- Then find query details of that pid from pg_stat_activity
select pid, 
       usename, 
       pg_blocking_pids(pid) as blocked_by, 
       query as blocked_query
from pg_stat_activity
where cardinality(pg_blocking_pids(pid)) > 0;

-- This query may give more details of blocker, but not sure if it runs ok
SELECT bl.pid     AS blocked_pid,
     a.usename  AS blocked_user,
     kl.pid     AS blocking_pid,
     ka.usename AS blocking_user,
     a.query    AS blocked_statement
FROM  pg_catalog.pg_locks         bl
 JOIN pg_catalog.pg_stat_activity a  ON a.pid = bl.pid
 JOIN pg_catalog.pg_locks         kl ON kl.transactionid = bl.transactionid AND kl.pid != bl.pid
 JOIN pg_catalog.pg_stat_activity ka ON ka.pid = kl.pid
WHERE NOT bl.granted;
