-- https://stackoverflow.com/questions/41369760/query-to-know-at-what-sample-percentage-stats-last-updated
SELECT 
    OBJECT_NAME(object_id) AS [ObjectName],
    [name] AS [StatisticName],
    STATS_DATE([object_id], 
    [stats_id]) AS [StatisticUpdateDate]
FROM 
    sys.stats;
