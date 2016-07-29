set lines 120
set pages 1000

column target_type format a20
column cluster_name format a20
column host_name format a25
column target_name format a25
column database_name format a25
column component_version format a10
column component_base_version format a10


spool listhostdb

/*
select distinct a.composite_target_name cluster_name, b.host_name, b.target_name database_name, c.component_version
from   mgmt_target_memberships a,
       mgmt$target b,
       mgmt$target_components c
where  a.member_target_name = b.host_name
and    a.composite_target_type='cluster'
and    a.member_target_type = 'host'
and    c.target_type='oracle_database'
and    c.host_name= b.host_name
order by 1, 2, 3;
*/

select a.composite_target_name cluster_name, b.host_name, b.target_name, b.component_version
from   mgmt_target_memberships a,
(select distinct target_type, host_name, target_name, component_version
from MGMT$TARGET_COMPONENTS where target_type='oracle_database'
) b
where a.member_target_name = b.host_name
and a.composite_target_type='cluster'
and a.member_target_type = 'host'
order by 1, 2, 4, 3
;


/*
select upper(a.composite_target_name) cluster_name, a.member_target_name host_name,
       b.system_config, b.freq, b.mem, b.disk, b.cpu_count, b.total_cpu_cores cores, b.physical_cpu_count phy_cpu, b.logical_cpu_count logical_cpu, b.virtual
from   mgmt_target_memberships a,
       mgmt$os_hw_summary b
where a.composite_target_type='cluster'
and   a.member_target_type = 'host'
and   a.member_target_name = b.host_name
order by 1,2;


select count(*) num_hosts,
       sum(b.mem) mem,
       sum(b.cpu_count) cpu_count,
       sum(b.total_cpu_cores) cores,
       sum(b.physical_cpu_count) phy_cpu,
       sum(b.logical_cpu_count) logical_cpu,
       avg(freq) freq_avg
from   mgmt_target_memberships a,
       mgmt$os_hw_summary b
where a.composite_target_type='cluster'
and   a.member_target_type = 'host'
and   a.member_target_name = b.host_name
;
*/


spool off

-- SQL>  desc MGMT$TARGET_COMPONENTS
--  Name                                                  Null?    Type
--  ----------------------------------------------------- -------- ------------------------------------
--  TARGET_NAME                                           NOT NULL VARCHAR2(256)
--  TARGET_TYPE                                           NOT NULL VARCHAR2(64)
--  TARGET_GUID                                           NOT NULL RAW(16)
--  HOST_NAME                                                      VARCHAR2(256)
--  HOME_NAME                                                      VARCHAR2(256)
--  HOME_TYPE                                                      VARCHAR2(11)
--  HOME_LOCATION                                         NOT NULL VARCHAR2(1024)
--  COMPONENT_NAME                                        NOT NULL VARCHAR2(128)
--  COMPONENT_EXTERNAL_NAME                               NOT NULL VARCHAR2(128)
--  COMPONENT_VERSION                                     NOT NULL VARCHAR2(64)
--  COMPONENT_BASE_VERSION                                NOT NULL VARCHAR2(64)
--  IS_TOP_LEVEL                                          NOT NULL VARCHAR2(1)
--  SNAPSHOT_GUID                                         NOT NULL RAW(16)
--

-- SQL> desc mgmt$target
--  Name                                                  Null?    Type
--  ----------------------------------------------------- -------- ------------------------------------
--  TARGET_NAME                                           NOT NULL VARCHAR2(256)
--  TARGET_TYPE                                           NOT NULL VARCHAR2(64)
--  TARGET_GUID                                           NOT NULL RAW(16)
--  TYPE_VERSION                                          NOT NULL VARCHAR2(8)
--  TYPE_QUALIFIER1                                                VARCHAR2(64)
--  TYPE_QUALIFIER2                                                VARCHAR2(64)
--  TYPE_QUALIFIER3                                                VARCHAR2(64)
--  TYPE_QUALIFIER4                                                VARCHAR2(64)
--  TYPE_QUALIFIER5                                                VARCHAR2(64)
--  EMD_URL                                                        VARCHAR2(1024)
--  TIMEZONE_REGION                                                VARCHAR2(64)
--  DISPLAY_NAME                                                   VARCHAR2(256)
--  HOST_NAME                                                      VARCHAR2(256)
--  LAST_METRIC_LOAD_TIME                                          DATE
--  TYPE_DISPLAY_NAME                                              VARCHAR2(128)
--  BROKEN_REASON                                                  NUMBER
--  BROKEN_STR                                                     VARCHAR2(512)
--  OWNER                                                          VARCHAR2(256)
--  LAST_LOAD_TIME_UTC                                             DATE
--  CREATION_DATE                                         NOT NULL DATE
--
