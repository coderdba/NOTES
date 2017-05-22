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
