--
-- Create local users in PDB environment
--

-- Change over to required PDB
alter session set container = PDB1;

-- Create roles 
create role perfdba_role;

-- Create users
-- NOTE - the initial profile will be 'DEFAULT' which is created at the container level already
--        However, if the local default profile does not have a password verify function associated with it
--        then we can use a common profile that has a password verify function associated with it 
--        The create-user statement below uses a common profile
--        ALTERNATIVELY - Create a local verify-function and associate it with the local default profile
--
create user dbaquery identified by dbaquery profile c##common_profile;
select username, default_tablespace, common from cdb_users where con_id=3 and username ='DBAQUERY';
alter user dbaquery default tablespace dbats;
select username, default_tablespace, common from cdb_users where con_id=3 and username ='DBAQUERY';

-- Grant local roles
grant perfdba_role to dbaquery;

-- Grant common roles
grant c##common_for_all_role to dbaquery;

-- Verify roles for the user
select grantee, granted_role, default_role, common, con_id from cdb_role_privs where grantee='DBAQUERY';

-- Set common profile for this user
alter user DBAQUERY profile c##common_profile;




