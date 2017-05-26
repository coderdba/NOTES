select sql_id from v$sql where
--cell_offload_eligible_bytes > 0 -- in 12c db
--or
io_cell_offload_returned_bytes > 0
;

select sql_id,
    io_cell_offload_eligible_bytes qualifying,
    io_cell_offload_eligible_bytes - io_cell_offload_returned_bytes actual,
    round(((io_cell_offload_eligible_bytes - io_cell_offload_returned_bytes)/io_cell_offload_eligible_bytes)*100, 2) io_saved_pct,
    sql_text
    from v$sql
    where io_cell_offload_returned_bytes> 0
    and instr(sql_text, 'emp') > 0
    and parsing_schema_name = 'BING';
