-- Finding blocking/locking queries in MS SQL (mssql)
-- https://stackoverflow.com/questions/4365970/finding-blocking-locking-queries-in-ms-sql-mssql

select wait_type, wait_time_ms from sys.dm_os_wait_stats

-- For completed waits
-- https://learn.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-wait-stats-transact-sql?view=sql-server-ver16
DBCC SQLPERF ('sys.dm_os_wait_stats', CLEAR);
GO

-- SQL Server SELECT statements causing blocking
-- https://stackoverflow.com/questions/1017177/sql-server-select-statements-causing-blocking

SELECT can block updates. A properly designed data model and query will only cause minimal blocking and not be an issue. 
*** The 'usual' WITH NOLOCK hint is almost always the wrong answer. 
*** The proper answer is to tune your query so it does not scan huge tables.

If the query is untunable then you should first consider SNAPSHOT ISOLATION level, 
second you should consider using DATABASE SNAPSHOTS and last option should be DIRTY READS 
(and is better to change the isolation level rather than using the NOLOCK HINT). Note that dirty reads, 
as the name clearly states, will return inconsistent data (eg. your total sheet may be unbalanced).

To perform dirty reads you can either:

 using (new TransactionScope(TransactionScopeOption.Required, 
 new TransactionOptions { 
 IsolationLevel = System.Transactions.IsolationLevel.ReadUncommitted }))
 {
 //Your code here
 }
or

SelectCommand = "SELECT * FROM Table1 WITH (NOLOCK) INNER JOIN Table2 WITH (NOLOCK) ..."
remember that you have to write WITH (NOLOCK) after every table you want to dirty read

-- Sleeping, awaiting command
-- https://techcommunity.microsoft.com/t5/sql-server-support-blog/how-it-works-what-is-a-sleeping-awaiting-command-session/ba-p/315486
This issue is as old as SQL Server.  In fact, it goes back to Sybase days but continues to fool and puzzle administrators.

A session with that status of sleeping / awaiting command is simply a client connection with no active query to the SQL Server. The table below shows the transitions from running to sleeping states for a session.

Connect	Running
Connect Completed	Sleeping / Awaiting Command
select @@VERSION	Running
select completed	Sleeping / Awaiting Command
The question usually arises around a session that is holding locks and its state is sleeping / awaiting command.  If the client has an open transaction and the client did not submit a commit or rollback command the state is sleeping / awaiting command.    I see this quite often with a procedure that times out.

Create proc myProc

As

Begin tran

Update authors ….

Waitfor delay ’10:00:00’   --- time out will occur here  (simulates long workload)

rollback

go

When run from the client with a 30 second query timeout the transaction will remain open because the client indicated it wanted to ‘cancel execution' 
and do no further processing.   To get automatic rollback in this situation transaction abort must be enabled.  
You now have an open transaction with a SPID sleeping/awaiting command.

The situation can be caused by many other variations but it is always a situation where the SQL Server is waiting for the next command from the client.   
Outside a physical connection problem these are always application design issues.

Bob Dorr
SQL Server Senior Escalation Engineer
  
