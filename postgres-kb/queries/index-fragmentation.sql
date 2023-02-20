-- https://dbalifeeasy.com/tag/postgresql-table-and-index-fragmentation/
CREATE EXTENSION pgstattuple;

-- Table fragmentation - “dead_tuple_percent” in %

SELECT * FROM pgstattuple('cdr_record');

select count(*) from cdr_record;

-- Index fragmentation - “leaf_fragmentation” in %

SELECT * FROM pgstatindex('idx_customers');

--

-- https://dba.stackexchange.com/questions/273556/how-do-we-select-fragmented-indexes-from-postgresql
CREATE EXTENSION pgstattuple;

SELECT i.indexrelid::regclass,
       s.leaf_fragmentation
FROM pg_index AS i
   JOIN pg_class AS t ON i.indexrelid = t.oid
   JOIN pg_opclass AS opc ON i.indclass[0] = opc.oid
   JOIN pg_am ON opc.opcmethod = pg_am.oid
   CROSS JOIN LATERAL pgstatindex(i.indexrelid) AS s
WHERE t.relkind = 'i'
  AND pg_am.amname = 'btree';
