-- https://dataedo.com/kb/query/postgresql/list-of-tables-by-their-size
-- https://www.ktexperts.com/data-fregmentation-in-postgresql
-- https://www.a2hosting.com/kb/developer-corner/postgresql/determining-the-size-of-postgresql-databases-and-tables

-- by relid - size, total size and dead tuples
select schemaname as table_schema,
       relname as table_name,
       pg_size_pretty(pg_relation_size(relid)) as data_size,
	   pg_size_pretty(pg_total_relation_size(relid)) as data_plus_index_size,
	   n_live_tup, n_dead_tup, last_autovacuum
from pg_catalog.pg_stat_all_tables
where n_dead_tup > 0
order by pg_relation_size(relid) desc;

-- by relid - size
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

-- size of a single table by schema.name directly from table
SELECT pg_size_pretty(pg_total_relation_size('sp.date1'))
from sp.date1;

