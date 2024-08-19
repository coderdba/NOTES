-- https://stackoverflow.com/questions/7395915/does-inserting-data-into-sql-server-lock-the-whole-table

sp_WhoIsActive @get_locks = 1
