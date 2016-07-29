set pages 1000
set lines 160

spool sysman

select object_type, object_name
--from user_objects
from all_objects
where object_type in ('TABLE', 'VIEW')
order by 1,2;

spool off
