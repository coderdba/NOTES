#exec > current_sql.out 2>> current_sql.out

exec >> current_sql_compact.out 2>> current_sql_compact.out

a=0

while [ $a -eq 0 ]
do

db2 connect to MYDB1 > /dev/null 2>> /dev/null
db2 -xvtf ./current_sql_compact.sql | grep -v "SELECT application_name"

sleep 15

done
