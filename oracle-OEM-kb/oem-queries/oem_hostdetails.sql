spool hostdetails

-- http://superuser.com/questions/311777/proc-cpuinfo-gives-cpu-info-per-core-or-per-thread

set lines 150
set pages 1500

column host_name     format a25
column system_config format a30
column freq          format 999999
column mem           format 999999
column disk          format 990.9
column cpu_count     format 99
column cores         format 99
column phy_cpu       format 99
column logical_cpu   format 99

select host_name, system_config, freq, mem, disk, cpu_count, total_cpu_cores cores, 
       physical_cpu_count phy_cpu, logical_cpu_count logical_cpu, virtual
from   mgmt$os_hw_summary
--where  host_name = 'myhost'
order by 2, 1;

spool off
