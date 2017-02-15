Rem
Rem Copyright (c) 2013,2015 Oracle. All rights reserved.
Rem
Rem    NAME
Rem     countstatsTSTZ.sql - Gives count of TimeStamp with TimeZone columns using stats info
Rem     if the stats are not up to date use countstarTSTZ.sql (slower)
Rem             Version 1.4
Rem
Rem    NOTES
Rem      * This script must be run using SQL*PLUS.
Rem      * This script must be connected AS SYSDBA to run.
Rem      * This script is mainly usefull for 11.2 and up .
Rem      * The database will NOT be restarted .
Rem      * NO downtime is needed for this script.
Rem      * This script is NOT required for upg_tzv_check.sql and upg_tzv_apply.sql
Rem
Rem    DESCRIPTION
Rem      Script to approximate how much TimeStamp with TimeZone data there is
Rem      in an database using num_row stats info
Rem              Useful when using DBMS_DST or the upg_tzv_check.sql
Rem      and upg_tzv_apply.sql scripts
Rem
Rem    MODIFIED   (MM/DD/YY)
Rem    gvermeir   01/08/15 - created from countstarTSTZ.sql
Rem    gvermeir   01/08/15 - renamed from countTSTZdata.sql to countstarTSTZ.sql
Rem    gvermeir   01/06/14 - only need to do one count(*) for each table
Rem    gvermeir   12/22/14 - added DISTINCT to rec
Rem    gvermeir   03/17/14 - added logging of time
Rem    gvermeir   05/13/13 - Initial release.
Rem
set FEEDBACK off
set SERVEROUTPUT on
-- Get time
VARIABLE V_TIME number
EXEC :V_TIME := DBMS_UTILITY.GET_TIME

-- Alter session to avoid performance issues
alter session set nls_sort='BINARY';

-- Set client_info so one can use:
-- select .... from V$SESSION where CLIENT_INFO = 'countstatsTSTZ';
EXEC DBMS_APPLICATION_INFO.SET_CLIENT_INFO('countstatsTSTZ');
whenever SQLERROR EXIT

-- Check if user is sys
declare
        V_CHECKVAR1                             varchar2(10 char);
begin
                execute immediate
                'select substr(SYS_CONTEXT(''USERENV'',''CURRENT_USER''),1,10) from dual' into V_CHECKVAR1 ;
                if V_CHECKVAR1 = 'SYS' then
                                null;
                        else
                                DBMS_OUTPUT.PUT_LINE('ERROR: Current connection is not a sysdba connection!');
                                RAISE_APPLICATION_ERROR(-20001,'Stopping script - see previous message .....');
                end if;
end;
/

whenever SQLERROR CONTINUE

EXEC DBMS_OUTPUT.PUT_LINE( ' . ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Amount of TSTZ data using num_rows stats info in DBA_TABLES.' );
EXEC DBMS_OUTPUT.PUT_LINE( ' . ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' For SYS tables first... ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Note: empty tables are not listed.' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Stat date  - Owner.Tablename.Columnname - num_rows  ' );
declare
        V_NUMROWS                               number;
        V_TOTALNUMROWS                  number;
        V_TOTALCOLS                             number;
        V_LASTANALYSE                   varchar2(10 char);
        V_STMT                                  varchar2(200 char);
        V_THISTABLE                             varchar2(80 char);
        V_PREVTABLE                             varchar2(80 char);
begin
        V_NUMROWS               := TO_NUMBER('0');
        V_TOTALNUMROWS  := TO_NUMBER('0');
        V_TOTALCOLS             := TO_NUMBER('0');
        V_THISTABLE             := null;
        V_PREVTABLE             := ' ';
-- not using ALL_TSTZ_TAB_COLS seen this is not known in 11.1 and lower
        for REC in ( select DISTINCT C.OWNER, C.TABLE_NAME , C.COLUMN_NAME
                        from DBA_TAB_COLS C, DBA_OBJECTS O
                        where C.OWNER=O.OWNER
                        and C.TABLE_NAME = O.OBJECT_NAME
                        and C.DATA_TYPE like '%WITH TIME ZONE'
                        and O.OBJECT_TYPE = 'TABLE'
                    and C.OWNER = 'SYS'
                        order by C.OWNER, C.TABLE_NAME, C.COLUMN_NAME)
                LOOP
                        V_THISTABLE     := ''||REC.OWNER || '"."' || REC.TABLE_NAME||'' ;
                        IF
                    V_PREVTABLE != V_THISTABLE
                        THEN
                                V_STMT :=  'select NUM_ROWS , to_char(LAST_ANALYZED,''DD/MM/YYYY'') from DBA_TABLES where OWNER = :X and TABLE_NAME = :Y ' ;
                                execute immediate V_STMT INTO V_NUMROWS, V_LASTANALYSE using REC.OWNER,REC.TABLE_NAME ;
                                IF V_NUMROWS > 0 THEN
                                        DBMS_OUTPUT.PUT_LINE( V_LASTANALYSE ||' - ' || REC.OWNER ||'.'|| REC.TABLE_NAME || '.'|| REC.COLUMN_NAME ||' - ' || V_NUMROWS );
                                        V_TOTALNUMROWS := V_TOTALNUMROWS + V_NUMROWS ;
                                END IF;
                        ELSE
                                IF V_NUMROWS > 0 THEN
                                        DBMS_OUTPUT.PUT_LINE( V_LASTANALYSE ||' - ' || REC.OWNER ||'.'|| REC.TABLE_NAME || '.'|| REC.COLUMN_NAME ||' - ' || V_NUMROWS );
                                        V_TOTALNUMROWS := V_TOTALNUMROWS + V_NUMROWS ;
                                END IF;
                        END IF;
                        V_PREVTABLE     := ''||REC.OWNER || '"."' || REC.TABLE_NAME||'' ;
                        V_TOTALCOLS  := V_TOTALCOLS + 1;
                        end LOOP;
        DBMS_OUTPUT.PUT_LINE( ' Total numrow of SYS TSTZ columns is : ' || TO_CHAR(V_TOTALNUMROWS) );
        DBMS_OUTPUT.PUT_LINE( ' There are in total '|| TO_CHAR(V_TOTALCOLS)||' non-SYS TSTZ columns.'  );
        end;
/

EXEC DBMS_OUTPUT.PUT_LINE( ' . ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' For non-SYS tables ... ' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Note: empty tables are not listed.' );
EXEC DBMS_OUTPUT.PUT_LINE( ' Stat date  - Owner.Tablename.Columnname - num_rows  ' );
declare
        V_NUMROWS                               number;
        V_TOTALNUMROWS                  number;
        V_TOTALCOLS                             number;
        V_LASTANALYSE                   varchar2(10 char);
        V_STMT                                  varchar2(200 char);
        V_THISTABLE                             varchar2(80 char);
        V_PREVTABLE                             varchar2(80 char);
begin
        V_NUMROWS               := TO_NUMBER('0');
        V_TOTALNUMROWS  := TO_NUMBER('0');
        V_TOTALCOLS             := TO_NUMBER('0');
        V_THISTABLE             := null;
        V_PREVTABLE             := ' ';
-- not using ALL_TSTZ_TAB_COLS seen this is not known in 11.1 and lower
        for REC in ( select DISTINCT C.OWNER, C.TABLE_NAME , C.COLUMN_NAME
                        from DBA_TAB_COLS C, DBA_OBJECTS O
                        where C.OWNER=O.OWNER
                        and C.TABLE_NAME = O.OBJECT_NAME
                        and C.DATA_TYPE like '%WITH TIME ZONE'
                        and O.OBJECT_TYPE = 'TABLE'
                    and C.OWNER != 'SYS'
                        order by C.OWNER, C.TABLE_NAME, C.COLUMN_NAME)
                LOOP
                        V_THISTABLE     := ''||REC.OWNER || '"."' || REC.TABLE_NAME||'' ;
                        IF
                    V_PREVTABLE != V_THISTABLE
                        THEN
                                V_STMT :=  'select NUM_ROWS , to_char(LAST_ANALYZED,''DD/MM/YYYY'') from DBA_TABLES where OWNER = :X and TABLE_NAME = :Y ' ;
                                execute immediate V_STMT INTO V_NUMROWS, V_LASTANALYSE using REC.OWNER,REC.TABLE_NAME ;
                                IF V_NUMROWS > 0 THEN
                                        DBMS_OUTPUT.PUT_LINE( V_LASTANALYSE ||' - ' || REC.OWNER ||'.'|| REC.TABLE_NAME || '.'|| REC.COLUMN_NAME ||' - ' || V_NUMROWS );
                                        V_TOTALNUMROWS := V_TOTALNUMROWS + V_NUMROWS ;
                                END IF;
                        ELSE
                                IF V_NUMROWS > 0 THEN
                                        DBMS_OUTPUT.PUT_LINE( V_LASTANALYSE ||' - ' || REC.OWNER ||'.'|| REC.TABLE_NAME || '.'|| REC.COLUMN_NAME ||' - ' || V_NUMROWS );
                                        V_TOTALNUMROWS := V_TOTALNUMROWS + V_NUMROWS ;
                                END IF;
                        END IF;
                        V_PREVTABLE     := ''||REC.OWNER || '"."' || REC.TABLE_NAME||'' ;
                        V_TOTALCOLS  := V_TOTALCOLS + 1;
                end LOOP;
        DBMS_OUTPUT.PUT_LINE( ' Total numrow of non-SYS TSTZ columns is : ' || TO_CHAR(V_TOTALNUMROWS) );
        DBMS_OUTPUT.PUT_LINE( ' There are in total '|| TO_CHAR(V_TOTALCOLS)||' non-SYS TSTZ columns.'  );
end;
/
-- Print time it took
EXEC :V_TIME :=  round((DBMS_UTILITY.GET_TIME - :V_TIME)/100/60)
EXEC DBMS_OUTPUT.PUT_LINE(' Total Minutes elapsed : '||:V_TIME)
set FEEDBACK on
-- End of countstatsTSTZ.sql
