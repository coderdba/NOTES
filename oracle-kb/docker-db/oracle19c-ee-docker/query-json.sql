---------------------------------
-- HELPFUL QUERIES TO COMBINE DATA
select a.name, b.name, c.name 
from
myschema.tenant_targets a, 
myschema.tenants b, 
myschema.targets c
where a.target_id = c.id 
and a.tenant_id = b.id;

-- Using json-search (also creating json search index will improve performance)
select * 
from targets t
where json_textcontains(t.TARGET_ATTRIBUTES, '$.cluster.processes', 'vm1');

-- Using on a json field
select * from targets where json_value(target_attributes, '$.wlcluster.app') = 'app1';

-- Querying on an array in the json
-- NOTE: THESE ARE NOT HELPFUL IN OUR DATA FOR TARGETS YET
select *
from   t1
where  json_exists(json_data, '$.words.pages?(@.number() == 40)');

select *  
from   targets t
where  json_exists(t.TARGET_ATTRIBUTES, '$.cluster.processes.node?(@.string() == 'vm1')'));

------------------------------------------------------
EXPLAIN PLANS

- with only json search index
SQL>  select * from targets where json_value(target_attributes, '$.wlcluster.app') = 'app1';

Execution Plan
----------------------------------------------------------
Plan hash value: 255216017

--------------------------------------------------------------------------------------------------------
| Id  | Operation                   | Name                     | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |                          |     1 |  1073 |     4   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| TARGETS                  |     1 |  1073 |     4   (0)| 00:00:01 |
|*  2 |   DOMAIN INDEX              | TARGETS_JSON_SEARCH_IDX1 |       |       |     4   (0)| 00:00:01 |
--------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   1 - filter(JSON_VALUE("TARGET_ATTRIBUTES" FORMAT JSON , '$.wlcluster.app' RETURNING
              VARCHAR2(4000) NULL ON ERROR)='app1')
   2 - access("CTXSYS"."CONTAINS"("TARGETS"."TARGET_ATTRIBUTES",'{app1} INPATH
              (/wlcluster/app)')>0)

Note
-----
   - dynamic statistics used: dynamic sampling (level=2)

-- with json field specific index added
SQL>  select * from targets where json_value(target_attributes, '$.wlcluster.app') = 'app1';

Execution Plan
----------------------------------------------------------
Plan hash value: 662454342

---------------------------------------------------------------------------------------------------------
| Id  | Operation                           | Name              | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                    |                   |     1 |  3063 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID BATCHED| TARGETS           |     1 |  3063 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN                  | TARGETS_JSON_IDX1 |     1 |       |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - access(JSON_VALUE("TARGET_ATTRIBUTES" FORMAT JSON , '$.wlcluster.app.string()' RETURNING
              VARCHAR2(4000) NULL ON ERROR)='app1')

Note
-----
   - dynamic statistics used: dynamic sampling (level=2)
