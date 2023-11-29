-- Create json datatype table in 19c: https://docs.oracle.com/en/database/oracle/oracle-database/19/adjsn/creating-a-table-with-a-json-column.html#GUID-E6CC0DCF-3D72-41EF-ACA4-B3BF54EE3CA0

-- JSON Search Indexes in 19c: https://blogs.oracle.com/database/post/search-indexes-for-json

/*
CREATE TABLE j_purchaseorder
  (id          VARCHAR2 (32) NOT NULL PRIMARY KEY,
   date_loaded TIMESTAMP (6) WITH TIME ZONE,
   po_document VARCHAR2 (2000)
   CONSTRAINT ensure_json CHECK (po_document IS JSON));
*/

CREATE TABLE tenants (
  ID                       NUMBER        GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1),
  NAME                     VARCHAR2(250) NOT NULL, 
  DESCRIPTION              VARCHAR2(250) NOT NULL,
  CONSTRAINT               tenants_pk PRIMARY KEY (ID),
  CONSTRAINT               tenants_name_uk UNIQUE (NAME)
);

CREATE TABLE targets (
        ID                  NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
        NAME                VARCHAR2(50) NOT NULL,
        TARGET_TYPE         VARCHAR2(10) CHECK (TARGET_TYPE IN ('linux', 'windows')),
        ENVIRONMENT         VARCHAR2(20) NOT NULL,
        TARGET_ATTRIBUTES   VARCHAR2(2000),
        CONSTRAINT target_ensure_json1 CHECK (TARGET_ATTRIBUTES IS JSON),
        CONSTRAINT targets_id_pk PRIMARY KEY (ID),
        CONSTRAINT targets_name_uk UNIQUE (NAME)
);

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

select a.name, b.name, c.name 
from
myschema.tenant_targets a, 
myschema.tenants b, 
myschema.targets c
where a.target_id = c.id 
and a.tenant_id = b.id;


