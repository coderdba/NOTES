// https://www.sqlshack.com/how-to-identify-and-resolve-sql-server-index-fragmentation/

--Basic Rebuild Command
ALTER INDEX Index_Name ON Table_Name REBUILD
 
--REBUILD Index with ONLINE OPTION
ALTER INDEX Index_Name ON Table_Name REBUILD WITH(ONLINE=ON) | WITH(ONLINE=ON)
