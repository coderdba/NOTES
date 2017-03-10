if [ $# -lt 1 ]
then
echo
echo Uage: $0 DB_UNIQUE_NAME
exit
echo
fi

srvctl stop database -d $1
srvctl start database -d $1 -o 'read only'
