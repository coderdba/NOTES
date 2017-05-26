select sql_id from v$sql where
--cell_offload_eligible_bytes > 0 -- in 12c db
--or
io_cell_offload_returned_bytes > 0
;
