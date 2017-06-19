-- http://arup.blogspot.in/2008/09/magic-of-block-change-tracking.html
select file#, con_id, completion_time, datafile_blocks, blocks_read, blocks, used_change_tracking
from v$backup_datafile
where file# = 1
order by 1;
