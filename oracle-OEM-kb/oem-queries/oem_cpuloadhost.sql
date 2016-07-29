spool cpuloadhost

set lines 100
set pages 1000
column target_name format a30
column cluster_name format a30
column host_name format a30
column column_label format a30
column avg format 90.99
column min format 90.99
column max format 90.99
column stdev format 90.99

prompt ==================================
prompt    DAILY CPU LOAD OF RAC HOSTS
prompt ==================================

select upper(a.composite_target_name) cluster_name, a.member_target_name host_name,
       b.rollup_timestamp, b.average avg, b.minimum min, b.maximum max, b.standard_deviation stdev
from   mgmt_target_memberships a,
       mgmt$metric_daily b
where a.composite_target_type='cluster'
and   a.member_target_type = 'host'
and   a.member_target_name = b.target_name
and   b.metric_name = 'Load'
and   b.metric_column = 'cpuUtil'
order by 1,2,3;

spool off


/*
select COMPOSITE_TARGET_NAME CLUSTER_NAME, MEMBER_TARGET_TYPE, MEMBER_TARGET_NAME
from MGMT_TARGET_MEMBERSHIPS
where COMPOSITE_TARGET_TYPE='cluster'
and   MEMBER_TARGET_TYPE = 'host'
order by 1,2,3;

SELECT column_label, value
FROM   mgmt$metric_current
WHERE  metric_name = 'Load'
  AND  metric_column = 'cpuUtil'
  AND  target_name = 'my.acme.com';


SELECT target_name, rollup_timestamp, average avg, minimum min, maximum max, standard_deviation stdev
FROM   mgmt$metric_daily
WHERE  metric_name = 'Load'
  AND  metric_column = 'cpuUtil'
  AND  target_name = 'd-82rm9k1'
order by 1, 2;


SQL> desc MGMT$METRIC_DAILY
 Name                                                  Null?    Type
 ----------------------------------------------------- -------- ------------------------------------
 TARGET_NAME                                           NOT NULL VARCHAR2(256)
 TARGET_TYPE                                           NOT NULL VARCHAR2(64)
 TARGET_GUID                                           NOT NULL RAW(16)
 METRIC_NAME                                           NOT NULL VARCHAR2(64)
 METRIC_COLUMN                                         NOT NULL VARCHAR2(64)
 METRIC_GUID                                           NOT NULL RAW(16)
 METRIC_LABEL                                                   VARCHAR2(64)
 COLUMN_LABEL                                                   VARCHAR2(256)
 KEY_VALUE                                             NOT NULL VARCHAR2(256)
 KEY_VALUE2                                            NOT NULL VARCHAR2(256)
 KEY_VALUE3                                            NOT NULL VARCHAR2(256)
 KEY_VALUE4                                            NOT NULL VARCHAR2(256)
 KEY_VALUE5                                            NOT NULL VARCHAR2(256)
 KEY_VALUE6                                            NOT NULL VARCHAR2(256)
 KEY_VALUE7                                            NOT NULL VARCHAR2(256)
 ROLLUP_TIMESTAMP                                      NOT NULL DATE
 SAMPLE_COUNT                                          NOT NULL NUMBER(38)
 AVERAGE                                                        NUMBER
 MINIMUM                                                        NUMBER
 MAXIMUM                                                        NUMBER
 STANDARD_DEVIATION                                             NUMBER
 TIMEZONE_REGION                                                VARCHAR2(64)

SQL> desc MGMT$METRIC_HOURLY
 Name                                                  Null?    Type
 ----------------------------------------------------- -------- ------------------------------------
 TARGET_NAME                                           NOT NULL VARCHAR2(256)
 TARGET_TYPE                                           NOT NULL VARCHAR2(64)
 TARGET_GUID                                           NOT NULL RAW(16)
 METRIC_NAME                                           NOT NULL VARCHAR2(64)
 METRIC_COLUMN                                         NOT NULL VARCHAR2(64)
 METRIC_GUID                                           NOT NULL RAW(16)
 METRIC_LABEL                                                   VARCHAR2(64)
 COLUMN_LABEL                                                   VARCHAR2(256)
 KEY_VALUE                                             NOT NULL VARCHAR2(256)
 KEY_VALUE2                                            NOT NULL VARCHAR2(256)
 KEY_VALUE3                                            NOT NULL VARCHAR2(256)
 KEY_VALUE4                                            NOT NULL VARCHAR2(256)
 KEY_VALUE5                                            NOT NULL VARCHAR2(256)
 KEY_VALUE6                                            NOT NULL VARCHAR2(256)
 KEY_VALUE7                                            NOT NULL VARCHAR2(256)
 ROLLUP_TIMESTAMP                                      NOT NULL DATE
 SAMPLE_COUNT                                          NOT NULL NUMBER(38)
 AVERAGE                                                        NUMBER
 MINIMUM                                                        NUMBER
 MAXIMUM                                                        NUMBER
 STANDARD_DEVIATION                                             NUMBER
 TIMEZONE_REGION                                                VARCHAR2(64)

SQL> desc MGMT$METRIC_CURRENT
 Name                                                  Null?    Type
 ----------------------------------------------------- -------- ------------------------------------
 TARGET_NAME                                                    VARCHAR2(256)
 TARGET_TYPE                                                    VARCHAR2(64)
 TARGET_GUID                                                    RAW(16)
 METRIC_NAME                                                    VARCHAR2(64)
 METRIC_TYPE                                                    NUMBER
 METRIC_COLUMN                                                  VARCHAR2(64)
 METRIC_GUID                                                    RAW(16)
 METRIC_LABEL                                                   VARCHAR2(64)
 COLUMN_LABEL                                                   VARCHAR2(256)
 COLLECTION_TIMESTAMP                                           DATE
 VALUE                                                          VARCHAR2(4000)
 KEY_VALUE                                                      VARCHAR2(256)
 KEY_VALUE2                                                     VARCHAR2(256)
 KEY_VALUE3                                                     VARCHAR2(256)
 KEY_VALUE4                                                     VARCHAR2(256)
 KEY_VALUE5                                                     VARCHAR2(256)
 KEY_VALUE6                                                     VARCHAR2(256)
 KEY_VALUE7                                                     VARCHAR2(256)
 TIMEZONE_REGION                                                VARCHAR2(64)

*/

