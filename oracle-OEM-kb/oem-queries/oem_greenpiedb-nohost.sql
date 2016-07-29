--
-- NOTE - To filter by prod, non-prod, os etc, join with mgmt$target_properties
--        You may join multiple subqueries one each for prod/non-prod, os, version etc
--

set lines 100
set pages 1000

-- INFO - TARGET_TYPE  of oracle_database denotes instance

column target_type format a25
column target_name format a25
column AVAILABILITY_STATUS format a40


prompt ===========================
prompt INFO - ALL COUNTS by status
prompt ===========================

select
--target_type,
AVAILABILITY_STATUS, count(*)
from  mgmt$availability_current
where target_type = 'oracle_database'
--and   availability_status != 'Target Up'
group by AVAILABILITY_STATUS
order by AVAILABILITY_STATUS;

