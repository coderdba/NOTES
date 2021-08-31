set pages 1000

prompt =============================
prompt QUERY DBA_AUDIT_TRAIL
prompt =============================
select
   os_username,
   username,
   terminal,
   to_char(timestamp,'MM-DD-YYYY HH24:MI:SS'),
   returncode
from
   dba_audit_trail;

prompt
prompt =============================
prompt QUERY DBA_AUDIT_SESSION
prompt =============================
select OS_USERNAME,USERNAME,TERMINAL,to_char(TIMESTAMP,'DD-MON-YY HH24:MI:SS')time,ACTION_NAME, RETURNCODE
from dba_audit_session;
