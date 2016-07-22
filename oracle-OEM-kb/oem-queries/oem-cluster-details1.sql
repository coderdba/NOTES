rem
rem cluster member details
rem


column CLUSTER_NAME  format a30
column MEMBER_TARGET_TYPE format a30
column MEMBER_TARGET_NAME format a30

set lines 100
set pages 1000

spool clusterdetails

prompt =======================
prompt     CLUSTER NODES
prompt =======================

select COMPOSITE_TARGET_NAME CLUSTER_NAME, MEMBER_TARGET_TYPE, MEMBER_TARGET_NAME
from MGMT_TARGET_MEMBERSHIPS
where COMPOSITE_TARGET_TYPE='cluster'
and   MEMBER_TARGET_TYPE = 'host'
order by 1,2,3;

prompt  ========================================
prompt      CLUSTER MEMBERS OTHER THAN NODES
prompt  ========================================

select COMPOSITE_TARGET_NAME CLUSTER_NAME, MEMBER_TARGET_TYPE, MEMBER_TARGET_NAME
from MGMT_TARGET_MEMBERSHIPS
where COMPOSITE_TARGET_TYPE='cluster'
and   MEMBER_TARGET_TYPE != 'host'
order by 1,2,3;

spool off
