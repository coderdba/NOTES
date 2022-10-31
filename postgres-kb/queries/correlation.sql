-- https://dba.stackexchange.com/questions/173088/how-to-use-the-covariance-and-variance-in-postgresql

select corr(height,weight) 
from people;

-- This may not work, but is a placeholder to try something like this
select corr(a.metric_value, b.metric_value) 
from 
(select metric_value from ai1.metric_table0 where metric_name = 'latency1') a,
(select metric_value from ai1.metric_table0 where metric_name = 'cpu') b;
