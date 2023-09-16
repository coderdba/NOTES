================
TABLES
================
select
table_name,
pg_size_pretty(pg_relation_size(quote_ident(table_name))),
pg_relation_size(quote_ident(table_name))
from information_schema.tables
where table_schema = 'public'
order by 3 desc;

select table_schema, table_name, pg_relation_size('"'||table_schema||'"."'||table_name||'"')
from information_schema.tables
order by 3;

select schemaname as table_schema,
       relname as table_name,
       pg_size_pretty(pg_relation_size(relid)) as data_size
from pg_catalog.pg_statio_user_tables
order by pg_relation_size(relid) desc;

===============
INDEXES
===============
select pg_size_pretty (pg_indexes_size('table_name'));
select pg_size_pretty(pg_relation_size('index_name'));,

select indexname, pg_size_pretty(pg_relation_size(indexname::regclass)) as size
from pg_indexes
where tablename = 'my_table';
