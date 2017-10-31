# script to check status of the db and services anytime
# $1 is the db_unique_name as argument to this script

srvctl config database -d $1
srvctl config service -d $1
srvctl status service -d $1
