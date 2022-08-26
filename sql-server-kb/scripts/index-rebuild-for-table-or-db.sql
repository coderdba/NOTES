https://www.sqlshack.com/how-to-identify-and-resolve-sql-server-index-fragmentation/

REBUILD clustered index over the table affects other indexes of the table as well because the REBUILD clustered index 
rebuilds the non-clustered index of the table as well. Perform rebuild operation on all indexes of the table or database together; 
a user can use DBCC DBREINDEX() command.

DBCC DBREINDEX ('DatabaseName', 'TableName');
