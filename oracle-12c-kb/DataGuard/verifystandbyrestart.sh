#!/bin/ksh -x
srvctl stop database -d DBUNIQUENAME_STBY
srvctl start database -d DBUNIQUENAME_STBY
srvctl config database -d DBUNIQUENAME_STBY
