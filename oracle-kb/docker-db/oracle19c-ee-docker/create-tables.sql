-- Create json datatype table in 19c: https://docs.oracle.com/en/database/oracle/oracle-database/19/adjsn/creating-a-table-with-a-json-column.html#GUID-E6CC0DCF-3D72-41EF-ACA4-B3BF54EE3CA0

-- For Indexes: JSON Search Indexes in 19c: https://blogs.oracle.com/database/post/search-indexes-for-json
-- For multivalue indexes: https://oracle-base.com/articles/21c/multivalue-function-based-indexes-for-json_exists-21c
-- For multivalue indexes, json_exists: https://docs.oracle.com/en/database/oracle/oracle-database/21/adjsn/condition-JSON_EXISTS.html

/*
CREATE TABLE j_purchaseorder
  (id          VARCHAR2 (32) NOT NULL PRIMARY KEY,
   date_loaded TIMESTAMP (6) WITH TIME ZONE,
   po_document VARCHAR2 (2000)
   CONSTRAINT ensure_json CHECK (po_document IS JSON));

create index custid on mytab ( jtext.customer.id.number() )
create index custname on mytab ( jtext.customer.name.string() )

create multivalue index creditsIdx
 on person_collection t (t.jdoc.person.creditscore[*].number());

create search index srchidx on person_collection_t (jdoc) for json

*/

---------------------------------
CREATE TABLE tenants (
  ID                       NUMBER        GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
  NAME                     VARCHAR2(250) NOT NULL, 
  DESCRIPTION              VARCHAR2(250) NOT NULL,
  CONSTRAINT               tenants_pk PRIMARY KEY (ID),
  CONSTRAINT               tenants_name_uk UNIQUE (NAME)
);

---------------------------------
CREATE TABLE targets (
        ID                  NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
        NAME                VARCHAR2(50) NOT NULL,
        TARGET_TYPE         VARCHAR2(10) CHECK (TARGET_TYPE IN ('linux', 'windows','weblogic','ibmmq')),
        ENVIRONMENT         VARCHAR2(20) NOT NULL,
        TARGET_ATTRIBUTES   VARCHAR2(2000),
        CONSTRAINT target_ensure_json1 CHECK (TARGET_ATTRIBUTES IS JSON),
        CONSTRAINT targets_id_pk PRIMARY KEY (ID),
        CONSTRAINT targets_name_uk UNIQUE (NAME)
);

-- Usual indexes
-- NOTE: PK and UK will already have indexes - no need to create them separately

-- Search Index which can do search all over the json
create search index targets_json_search_idx1 on targets (TARGET_ATTRIBUTES) for json;

-- To search individual json fields
-- NOTE: This is not working yet
create index targets_json_idx1 on targets ( TARGET_ATTRIBUTES.wlcluster.app.string() );

--------------------------------- 
CREATE TABLE tenant_targets (
    ID                 NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
    NAME               VARCHAR2(50) NOT NULL,
    TENANT_ID          NUMBER NOT NULL,
    TARGET_ID          NUMBER NOT NULL,
    CONSTRAINT tenant_targets_pk PRIMARY KEY (ID),
    CONSTRAINT tenant_targets_to_tenants_fk FOREIGN KEY (TENANT_ID) REFERENCES tenants(ID),
    CONSTRAINT tenant_targets_to_targets_fk FOREIGN KEY (TARGET_ID) REFERENCES targets(ID),
    CONSTRAINT tenant_and_target_uk UNIQUE (TENANT_ID, NAME)
);

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
