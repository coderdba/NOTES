// https://www.sqlshack.com/how-to-identify-and-resolve-sql-server-index-fragmentation/
The REORGANIZE INDEX command reorders the index page by expelling the free or unused space on the page. 
Ideally, index pages are reordered physically in the data file. 
REORGANIZE does not drop and create the index but simply restructure the information on the page. 
REORGANIZE does not have any offline choice, and REORGANIZE does not affect the statistics compared to the REBUILD option. 
REORGANIZE performs online always.

ALTER INDEX IX_OrderTracking_SalesOrderID ON Sales.OrderTracking REORGANIZE
