#!/bin/ksh

export ORACLE_SID=INSTANCE1
export ORACLE_HOME=/u01/app/oracle/product/11.2.0.4
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export PATH=/bin:/usr/bin:/etc:/usr/etc:/usr/local/bin:/usr/lib:/usr/sbin:/usr/ccs/bin:/usr/ucb:/home/oracle/bin:/u01/app/oracle/product/11.2.0.4/bin:/usr/bin/X11:sbin:/usr/lib64/qt-3.3/bin:/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/opt/dell/srvadmin/bin.
export TNS_ADMIN=/usr/local/tns
#export NLS_DATE_FORMAT="YYYY-MM-DD HH24:MI:SS"

rman target / <<EOF

run
{
allocate channel c1 device type disk;
allocate channel c2 device type disk;
allocate channel c3 device type disk;
allocate channel c4 device type disk;
allocate channel c5 device type disk;
allocate channel c6 device type disk;
allocate channel c7 device type disk;
allocate channel c8 device type disk;

set until time "to_date('19-MAY-2017 01:00:00','DD-MON-YYYY HH24:MI:SS')";

restore database ;

recover database ;

}

EOF
