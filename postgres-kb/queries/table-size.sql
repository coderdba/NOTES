-- https://dataedo.com/kb/query/postgresql/list-of-tables-by-their-size
-- https://www.ktexperts.com/data-fregmentation-in-postgresql
-- https://www.a2hosting.com/kb/developer-corner/postgresql/determining-the-size-of-postgresql-databases-and-tables

SELECT pg_size_pretty(pg_total_relation_size('sp.date1'))
from sp.date1;

select schemaname as table_schema,
       relname as table_name,
       pg_size_pretty(pg_relation_size(relid)) as data_size
from pg_catalog.pg_stat_all_tables
order by pg_relation_size(relid) desc;

select schemaname as table_schema,
       relname as table_name,
       pg_size_pretty(pg_relation_size(relid)) as data_size
from pg_catalog.pg_statio_user_tables
order by pg_relation_size(relid) desc;

SELECT pg_size_pretty(pg_total_relation_size('sp.date1'))
from sp.date1;

