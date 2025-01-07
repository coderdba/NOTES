-- https://stackoverflow.com/questions/41369760/query-to-know-at-what-sample-percentage-stats-last-updated
select stats.object_id,
        stats.name stat_name,
        stats.stats_id,
        objects.name table_name,
        stats_date(stats.object_id, stats.stats_id) last_stat_update,
        sp.rows_sampled rows_sampled_when_last_stat_update,
        sp.rows total_rows_when_last_stat_update,
        ((sp.rows_sampled) / (sp.rows)) * 100 percent_rows_sampled,
        sp.modification_counter changes_since_last_stat_update
   from sys.objects
   join sys.stats
     on stats.object_id = objects.object_id 
  cross apply sys.dm_db_stats_properties(stats.object_id, stats.stats_id) sp
  where objects.type_desc = 'USER_TABLE'
    
SELECT 
    OBJECT_NAME(object_id) AS [ObjectName],
    [name] AS [StatisticName],
    STATS_DATE([object_id], 
    [stats_id]) AS [StatisticUpdateDate]
FROM 
    sys.stats;

SELECT 
    s.name AS StatsName,
    sp.last_updated AS LastUpdated,
    sp.rows AS Row_Count,
    sp.rows_sampled AS RowsSampled,
    sp.steps AS Steps,
    sp.unfiltered_rows AS UnfilteredRows
FROM 
    sys.stats AS s
CROSS APPLY 
    sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
WHERE 
    s.object_id = OBJECT_ID('YourTableName');
