              SELECT
                  r.blocking_session_id AS BlockingSPID,
                  r.session_id AS BlockedSPID,
                  r.wait_type,
                  r.wait_time,
                  r.wait_resource,
                  DB_NAME(r.database_id) AS BlockedDatabaseName,
                  'DB:'+DB_NAME(r.database_id)+',Wait Type:'+r.wait_type+',Wait Resource:'+r.wait_resource as Text
              FROM
                  sys.dm_exec_requests r
              CROSS APPLY
                  sys.dm_exec_sql_text(r.sql_handle) AS t
              WHERE
                  r.blocking_session_id <> 0;
