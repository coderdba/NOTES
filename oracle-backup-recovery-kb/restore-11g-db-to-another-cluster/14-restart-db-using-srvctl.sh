#!/bin/ksh -x
srvctl stop database -d DB_UNIQUE_NAME
srvctl start database -d DB_UNIQUE_NAME
srvctl status database -d DB_UNIQUE_NAME
