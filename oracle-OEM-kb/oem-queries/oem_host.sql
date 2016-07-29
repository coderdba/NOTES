set pages 500
set lines 100

spool host

select *
--host_name, system_config, freq, mem, disk, cpu_count, total_cpu_cores cores, physical_cpu_count phy_cpu, 
  logical_cpu_count logical_cpu, virtual
from   mgmt$os_hw_summary
where  host_name = 'myhostname'
order by 2, 1;

spool off
