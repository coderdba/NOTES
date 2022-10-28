-- https://gis.stackexchange.com/questions/57582/group-by-timestamp-interval-10-minutes-postgresql
-- 10 minute grouping based on timestamp column in a table
-- group by that period
-- get sum, count, avg etc


select count(*),
to_timestamp(floor((extract('epoch' from date_time) / 600 )) * 600)
AT TIME ZONE 'UTC' as interval_alias
FROM ai1.metric_table0 GROUP BY interval_alias;

select count(*), avg(metric_value),
to_timestamp(floor((extract('epoch' from date_time) / 600 )) * 600)
AT TIME ZONE 'UTC' as interval_alias
FROM ai1.metric_table0 GROUP BY interval_alias;

/**** THE TABLE
mydb=> \d ai1.metric_table0
                        Table "ai1.metric_table0"
    Column    |           Type           | Collation | Nullable | Default
--------------+--------------------------+-----------+----------+---------
 date_time    | timestamp with time zone |           | not null |
 metric_name  | character varying(50)    |           | not null |
 metric_value | double precision         |           | not null |
Indexes:
    "metric_table0_pk" PRIMARY KEY, btree (date_time, metric_name)
******/

select count(*),
to_timestamp(floor((extract('epoch' from date_time) / 600 )) * 600)
AT TIME ZONE 'UTC' as interval_alias
FROM ai1.metric_table0 GROUP BY interval_alias;

select count(*), avg(metric_value),
to_timestamp(floor((extract('epoch' from date_time) / 600 )) * 600)
AT TIME ZONE 'UTC' as interval_alias
FROM ai1.metric_table0
GROUP BY interval_alias
ORDER BY interval_alias;

select count(*), avg(metric_value),
to_timestamp(floor((extract('epoch' from date_time) / 600 )) * 600)
AT TIME ZONE 'UTC' as interval_alias
FROM ai1.metric_table0
WHERE metric_name = 'cpu'
GROUP BY interval_alias
ORDER BY interval_alias;

select count(*) metric_count, avg(metric_value) metric_value_avg,
to_timestamp(floor((extract('epoch' from date_time) / 600 )) * 600)
AT TIME ZONE 'UTC' as interval_alias
FROM ai1.metric_table0
WHERE metric_name = 'cpu'
GROUP BY interval_alias
HAVING avg(metric_value) > 45
ORDER BY interval_alias;

select count(*) metric_count,
avg(metric_value) metric_value_avg,
max(metric_value) metric_value_max,
min(metric_value) metric_value_min,
to_timestamp(floor((extract('epoch' from date_time) / 600 )) * 600)
AT TIME ZONE 'UTC' as interval_alias
FROM ai1.metric_table0
WHERE metric_name = 'cpu'
GROUP BY interval_alias
HAVING avg(metric_value) > 45
ORDER BY interval_alias;
