set echo on

create pfile='/tmp/pfilenew.ora' from spfile;
create spfile='+DATA_DG01' from pfile='/tmp/pfilenew.ora';

set echo off
