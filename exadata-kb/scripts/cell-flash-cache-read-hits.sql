select statistic#, value
    from v$mystat
    where statistic# in (select statistic# from v$statname where name = 'cell flash cache read hits');
 
