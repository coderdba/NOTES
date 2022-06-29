SELECT
application_name ||  ' ' ||
application_handle || ' ' ||
elapsed_time_sec || ' ' ||
rows_read ||  ' ' ||
substr(stmt_text,1,1500)
FROM
sysibmadm.mon_current_sql
where application_name = 'Import'
and   elapsed_time_sec > 2
ORDER BY elapsed_time_sec DESC
FETCH FIRST 50 ROWS ONLY;
