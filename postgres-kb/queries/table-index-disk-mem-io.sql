select 
schemaname, relname, 
sum(heap_blks_hit+toast_blks_hit) as table_blocks_memory_read, 
sum(heap_blks_read+toast_blks_read) table_blocks_disk_read,
sum(idx_blks_hit+tidx_blks_hit) index_blocks_memory_read, 
sum(heap_blks_read+toast_blks_read)index_blocks_disk_read
from pg_statio_all_tables
group by schemaname, relname
having (sum(heap_blks_hit+toast_blks_hit) > 0 or sum(heap_blks_read+toast_blks_read) > 0)
order by schemaname, relname;
