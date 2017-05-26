select *
    from v$mystat
    where statistic# = (select statistic# from v$statname where name = 'cell physical IO bytes saved by storage index');
