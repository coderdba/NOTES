SELECT 
coalesce(datname, '-') as DbName,
coalesce(numbackends, 0) as BackendConnections,
Round((blks_hit::decimal/(blks_hit::decimal + blks_read::decimal))::decimal, 4) AS CacheHitRatio,
coalesce(blks_read, 0) as BlksRead,
coalesce(blks_hit, 0) as BlksHit,
coalesce(blk_read_time, 0) as BlkReadTime,
coalesce(blk_write_time, 0) as BlkWriteTime,
coalesce(deadlocks, 0) as Deadlocks,
coalesce(temp_bytes, 0) as TempBytes,
coalesce(xact_commit, 0) as Commits,
coalesce(xact_rollback, 0) as Rollbacks
FROM pg_stat_database
WHERE (blks_hit + blks_read) > 0
ORDER BY DbName;
