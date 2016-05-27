--
-- Create common users
--
--
-- Help: http://oracle-base.com/articles/12c/multitenant-manage-users-and-privileges-for-cdb-and-pdb-12cr1.php#create-common-users
--

create user c##user1 identified by user#1234;
-- container=all need not be specified 

grant connect to c##user1 container=all;
-- container=all is important here, otherwise cannot connect to PDBs using this user

-- Give privilege specific to a PDB
alter session set container = PDB1;
grant select_catalog_role to c##user1;

-- Verify which role/privilege has been provided to this user in each cdb/pdb
select * from cdb_role_privs where grantee='C##USER1';
select * from cdb_sys_privs where grantee='C##USER1';
