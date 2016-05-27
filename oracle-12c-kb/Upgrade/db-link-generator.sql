set pages 1000
set lines 200

spool db-link-creator.sql

SELECT 'CREATE '||DECODE(U.NAME,'PUBLIC','public ')||'DATABASE LINK '||CHR(10)
||DECODE(U.NAME,'PUBLIC',Null, 'SYS','',U.NAME||'.')|| L.NAME||chr(10)
||'CONNECT TO ' || L.USERID || ' IDENTIFIED BY "'||L.PASSWORD||'" USING
'''||L.HOST||''''
||chr(10)||';' TEXT
FROM SYS.LINK$ L, SYS.USER$ U
WHERE L.OWNER# = U.USER#;

spool off
