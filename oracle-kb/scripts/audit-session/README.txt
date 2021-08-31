================================
AUDITING CREATE SESSION
================================

REFERENCES
https://community.oracle.com/tech/developers/discussion/848157/auditing-connection-info
http://www.dba-oracle.com/t_tracking_counting_failed_logon_signon_attempts.htm
https://www.netwrix.com/how_to_track_down_failed_oracle_logon_attempts.html
https://ramkedem.com/en/oracle-auditing-examples/


NOTE
To audit a specific PDB then go to that PDB and then run these scripts

$ sqlplus / as sysdba

SQL> alter session set container = XEPDB1;

TESTING
Run the audit-set sql
Run a few successful and failed connections
Run the audit-query sqls to verify audit was done or not
