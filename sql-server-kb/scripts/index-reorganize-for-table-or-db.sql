https://www.sqlshack.com/how-to-identify-and-resolve-sql-server-index-fragmentation/
To perform the REORGANIZE index operation on all indexes of the table or database together, the user can use the DBCC INDEXDEFRAG() command:

DBCC INDEXDEFRAG('DatabaseName', 'TableName');
