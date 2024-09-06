-- https://www.databasejournal.com/oracle/monitoring-tablespace-usage-in-oracle/

-- Option 1
DBA_TABLESPACE_USAGE_METRICS

-- Option 2
DBA_FREE_SPACE

-- Option 3 (maybe better one)

set linesize 132 tab off trimspool on
set pagesize 105
set pause off
set echo off
set feedb on

column "TOTAL ALLOC (MB)" format 9,999,990.00
column "TOTAL PHYS ALLOC (MB)" format 9,999,990.00
column "USED (MB)" format  9,999,990.00
column "FREE (MB)" format 9,999,990.00
column "% USED" format 990.00

select a.tablespace_name,
       a.bytes_alloc/(1024*1024) "TOTAL ALLOC (MB)",
       a.physical_bytes/(1024*1024) "TOTAL PHYS ALLOC (MB)",
       nvl(b.tot_used,0)/(1024*1024) "USED (MB)",
       (nvl(b.tot_used,0)/a.bytes_alloc)*100 "% USED"
from ( select tablespace_name,
       sum(bytes) physical_bytes,
       sum(decode(autoextensible,'NO',bytes,'YES',maxbytes)) bytes_alloc
       from dba_data_files
       group by tablespace_name ) a,
     ( select tablespace_name, sum(bytes) tot_used
       from dba_segments
       group by tablespace_name ) b
where a.tablespace_name = b.tablespace_name (+)
--and   (nvl(b.tot_used,0)/a.bytes_alloc)*100 > 10
and   a.tablespace_name not in (select distinct tablespace_name from dba_temp_files)
and   a.tablespace_name not like 'UNDO%'
order by 1
--order by 5
/
