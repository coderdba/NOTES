-- https://dataedo.com/kb/query/postgresql/list-of-tables-by-their-size
-- https://www.ktexperts.com/data-fregmentation-in-postgresql
-- https://www.a2hosting.com/kb/developer-corner/postgresql/determining-the-size-of-postgresql-databases-and-tables

select schemaname as table_schema,
       relname as table_name,
       pg_size_pretty(pg_relation_size(relid)) as data_size,
	   pg_size_pretty(pg_total_relation_size(relid)) as data_plus_index_size,
	   n_live_tup, n_dead_tup, last_autovacuum
from pg_catalog.pg_stat_all_tables
where n_dead_tup > 0
order by pg_relation_size(relid) desc;
