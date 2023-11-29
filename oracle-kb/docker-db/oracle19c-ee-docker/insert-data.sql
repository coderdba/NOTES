-- TENANTS 
insert into tenants (name, description) values ('at', 'at');
insert into tenants (name, description) values ('wl', 'weblogic');
insert into tenants (name, description) values ('imq', 'ibm mq');

-- TARGETS
CREATE TABLE targets (
        ID                  NUMBER GENERATED ALWAYS AS IDENTITY (START WITH 1 INCREMENT BY 1),
        NAME                VARCHAR2(50) NOT NULL,
        TARGET_TYPE         VARCHAR2(10) CHECK (TARGET_TYPE IN ('linux', 'windows', 'weblogic', 'ibmmq')),
        ENVIRONMENT         VARCHAR2(20) NOT NULL,
        TARGET_ATTRIBUTES   VARCHAR2(2000),
        CONSTRAINT target_ensure_json1 CHECK (TARGET_ATTRIBUTES IS JSON),
        CONSTRAINT targets_id_pk PRIMARY KEY (ID),
        CONSTRAINT targets_name_uk UNIQUE (NAME)
);

insert into targets (name, target_type, environment, target_attributes) values
('wl-app1-cluster1', 'weblogic', 'dev', 
  '{"cluster":{"app":"app1",  
    "processes":{{"type": "node manager", "name":"nm1", "node": "vm1"},
                 {"type": "mgmt server", "name":"ms1", "node": "vm1"},
                 {"type": "mgmt server", "name":"ms2", "node": "vm1"},
                 {"type": "node manager", "name":"nm1", "node": "vm2"},
                 {"type": "mgmt server", "name":"ms1", "node": "vm2"}}}');
