#!/bin/ksh
#------------------------------------------------------------------------------------------
#
# del_database_rac.sh
#
# To drop/delete a database
#
# http://www.dbaexpert.com/blog/dbca-delete-database-in-silent-mode-2/
#
#------------------------------------------------------------------------------------------

script=$0
script_basename=`basename $0`
script_dirname=`dirname $0`

if [ $# -ne 1 ]
then
    echo "ERR - Insufficient parameters"
    echo "Usage - $script_basename DB_UNIQUE_NAME"
else
    DB_UNIQUE_NAME=$1
fi

echo "INFO - Stopping the database $DB_UNIQUE_NAME"
srvctl stop database -d $DB_UNIQUE_NAME

echo "INFO - Removing the database $DB_UNIQUE_NAME"
dbca -silent -deleteDatabase -sourceDB $DB_UNIQUE_NAME

if [$? -eq 0]
then
    echo "INFO - Removing database configuration from CRS"
    srvctl remove database -d RL4DB1_TTCE
    
    echo "INFO - Remove standby database in the standby cluster if you dont need it"
    echo
    echo ======================================================================
    echo "INFO - REMOVE ASM FILES FOR THIS DATABASE MANUALLY USING 'ASMCMD' "
    echo ======================================================================
else
    echo "ERR - Error during database deletion using dbca"
fi




