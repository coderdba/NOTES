#!/bin/ksh
#------------------------------------------------------------------------------------------
#
# del_instance_rac.sh
#
# To drop/delete an instance of a RAC database
#
# http://oracle-base.com/articles/rac/delete-an-instance-from-an-oracle-rac-database.php
#------------------------------------------------------------------------------------------

script=$0
script_basename=`basename $0`
script_dirname=`dirname $0`

if [ $# -ne 4 ]
then
    echo "ERR - Insufficient parameters"
    echo "Usage - $script_basename DB_UNIQUE_NAME"
else
    DB_UNIQUE_NAME=$1
    INSTANCE_NAME=$2
    NODE_NAME=$3
    SYS_PASSWORD=$4
fi

echo "INFO - Removing the instance $INSTANCE_NAME of database $DB_UNIQUE_NAME"
dbca -silent -deleteInstance -nodeList $NODE_NAME -gdbName $DB_UNIQUE_NAME -instanceName $INSTANCE_NAME -sysDBAUserName sys -sysDBAPassword $SYS_PASSWORD

# then, remove the instance from CRS using srvctl command

