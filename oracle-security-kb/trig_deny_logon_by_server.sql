CREATE OR REPLACE TRIGGER trig_deny_logon_by_server AFTER LOGON ON DATABASE
DECLARE

v_machine varchar2(64);

BEGIN

--select machine
--into   v_machine
--from   v$session
--where  sid = (select sid from v$mystat where rownum = 1 );

select sys_context ('userenv', 'host')
into   v_machine
from dual;

IF v_machine in ('servernName', 'serverName.domain.com')
THEN

-- You can write an audit portion to insert the event to a table here

RAISE_APPLICATION_ERROR(-20001, 'You are logging on from an unauthorized server.  You are being booted out');

END IF;

END;
/
