-- TENANTS 
insert into tenants (name, description) values ('at', 'at');
insert into tenants (name, description) values ('wl', 'weblogic');
insert into tenants (name, description) values ('imq', 'ibm mq');

-- TARGETS
insert into targets (name, target_type, environment, target_attributes) values
('wl-app1-cluster1', 'weblogic', 'dev',
'{"cluster":
    {"app":"app1",  
    "processes":[{"type": "node manager", "name":"nm1", "node": "vm1"},
                 {"type": "mgmt server", "name":"ms1", "node": "vm1"},
                 {"type": "mgmt server", "name":"ms2", "node": "vm1"},
                 {"type": "node manager", "name":"nm1", "node": "vm2"},
                 {"type": "mgmt server", "name":"ms1", "node": "vm2"}]
    }
}'
);
