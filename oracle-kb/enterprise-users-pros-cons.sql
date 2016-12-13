====================================================
ENTERPRISE USERS PROS AND CONS
====================================================
Enterprise users are LDAP authenticated users using products like OID, Radiant Logic VDS etc.

Those users are NOT created in database - so, dba_users will not show them.
They are created in OID/VDS.
One or more global users are created in the database, and are associated with the enterprise users defined in OID/VDS.

====================================================================================================================
CON1 - ENTERPRISE USERNAME IS NOT CAPTURED IN DATABASE VIEWS LIKE V$SESSION, DBA_AUDIT_TRAIL etc
====================================================================================================================
V$SESSION and DBA_AUDIT_TRAIL etc views DO NOT show the enterprise user.  They show only the global user.
Only Logon and Logoff activities logged in the audit views show enterprise user name.
In DBA_AUDIT_TRAIL the GLOBAL_UID points to the enterprise user which needs to be deciphered from OID/VDS.
There is a way to populate the enterprise user info into v$session - but that needs a trigger at database level.

====================================================================================================================
CON2 - WILL NEED ELABORATE DESIGN AND SETUP OF ENTERPRISE USER HEIRARCHY
====================================================================================================================
Mapping of local and global roles at DB and again corresponding roles in OID/VDS are required
Same usernames can be used across different app databases - that can create confusion on roles and privileges

