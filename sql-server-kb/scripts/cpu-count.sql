SELECT
   (cpu_count / hyperthread_ratio) AS Number_of_PhysicalCPUs,
   CPU_Count AS Number_of_LogicalCPUs
FROM sys.dm_os_sys_info
