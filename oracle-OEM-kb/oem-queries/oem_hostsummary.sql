spool hostsummary

-- http://superuser.com/questions/311777/proc-cpuinfo-gives-cpu-info-per-core-or-per-thread

set lines 150
set pages 1500

column cluster_name  format a16
column num_hosts     format 999
column host_name     format a25
column system_config format a30
column freq          format 999999
column freq_avg      format 999999
column mem           format 999999999
column disk          format 999999
column cpu_count     format 99990
column cores         format 99990
column phy_cpu       format 99990
column logical_cpu   format 99990
column RAC_HOST_COUNT_TOTAL   format 99999999999999999990


prompt
prompt==================================================
prompt Oracle DB Servers - Hardware GRAND TOTAL
prompt==================================================
prompt

select count(*) num_hosts,
       sum(a.mem) mem,
       sum(a.cpu_count) cpu_count,
       sum(a.total_cpu_cores) cores,
       sum(a.physical_cpu_count) phy_cpu,
       sum(a.logical_cpu_count) logical_cpu,
       avg(freq) freq_avg
from  mgmt$os_hw_summary a
;

prompt
prompt==================================================
prompt Oracle DB Servers - Hardware Total by O/S GROUPS
prompt==================================================
prompt


select 'Redhat' os,
       count(*) num_hosts,
       sum(a.mem) mem,
       sum(a.cpu_count) cpu_count,
       sum(a.total_cpu_cores) cores,
       sum(a.physical_cpu_count) phy_cpu,
       sum(a.logical_cpu_count) logical_cpu,
       avg(freq) freq_avg
from  mgmt$os_hw_summary a
where a.os_summary like 'Red%'
--
union
--
select 'AIX' os,
       count(*) num_hosts,
       sum(a.mem) mem,
       sum(a.cpu_count) cpu_count,
       sum(a.total_cpu_cores) cores,
       sum(a.physical_cpu_count) phy_cpu,
       sum(a.logical_cpu_count) logical_cpu,
       avg(freq) freq_avg
from  mgmt$os_hw_summary a
where a.os_summary like 'AIX%'
--
union
--
select 'Solaris' os,
       count(*) num_hosts,
       sum(a.mem) mem,
       sum(a.cpu_count) cpu_count,
       sum(a.total_cpu_cores) cores,
       sum(a.physical_cpu_count) phy_cpu,
       sum(a.logical_cpu_count) logical_cpu,
       avg(freq) freq_avg
from  mgmt$os_hw_summary a
where a.os_summary like 'Sun%'
;


prompt
prompt==================================================
prompt Oracle DB Servers - Hardware Total by O/S
prompt==================================================
prompt

select a.os_summary,
       count(*) num_hosts,
       sum(a.mem) mem,
       sum(a.cpu_count) cpu_count,
       sum(a.total_cpu_cores) cores,
       sum(a.physical_cpu_count) phy_cpu,
       sum(a.logical_cpu_count) logical_cpu,
       avg(freq) freq_avg
from  mgmt$os_hw_summary a
group by a.os_summary
order by a.os_summary
;

prompt
prompt======================================
prompt Oracle DB Servers - Host Details
prompt======================================
prompt

select a.host_name, a.os_summary,
       a.system_config, a.vendor_name, a.os_vendor, a.distributor_version,
       a.freq, a.mem, a.disk, a.cpu_count, a.total_cpu_cores cores,
       a.physical_cpu_count phy_cpu, a.logical_cpu_count logical_cpu, a.virtual
from   mgmt$os_hw_summary a
order by 2, 1;

spool off
