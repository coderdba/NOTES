#!/bin/bash

# Example record
# DETAIL,FRAME1,CLUS1,DB1,9999,Sun,23,D,1,Mon,,,,Tue,23,I,1,Wed,,,,Thu,23,D,2,Fri,,,,Sat,23,I,2
# DETAIL,FRAME1,CLUS1,DB2,9999,744265,Sun,22,I,2,Mon,22,D,1,Tue,,,,Wed,22,I,1,Thu,,,,Fri,22,D,2,Sat,,,
# DETAIL,FRAME1,CLUS1,DB3,9999,312077,Sun,21,I,1,Mon,,,,Tue,21,D,1,Wed,,,,Thu,21,I,2,Fri,,,,Sat,21,D,2
# DETAIL,FRAME1,CLUS2,DB1,9999,21708173,Sun,,,,Mon,0,D,1,Tue, ,,,Wed,0,I,1,Thu,,,,Fri,0,I,2,Sat,1,D,1

set_backup_script()
{
 
backup_type=$1

if [ "$backup_type" == "D" ]
then
      export backup_script="full_backup_script"
else

      export backup_script="incr_backup_script"
fi

}

set_cron_day()
{

day=$1

case $day in
sun) export cron_day=0;;
mon) export cron_day=1;;
tue) export cron_day=2;;
wed) export cron_day=3;;
thu) export cron_day=4;;
fri) export cron_day=5;;
sat) export cron_day=6;;
*) export cron_day=99;;
esac

}

print_cron_entry()
{
db=$1
day=$2
hr=$3
type=$4
node=$5

echo $db $day $hr $type $node
if [ "$hr" == "" ] || (echo $hr | grep "^ " > /dev/null 2>> /dev/null)
then
     return
fi

set_backup_script $type
set_cron_day $day

cronline="${hr},*,*,${cron_day} ${backup_script} ${db} ON NODE $node"

echo $cronline

}

# MAIN

cat x | grep "DETAIL" | while read line
do

echo
echo $line
 
db_unique_name=`echo $line | cut -d, -f4`
# Sunday to Saturady
schedule_day=`echo $line | cut -d, -f6`
schedule_hr=`echo $line | cut -d, -f7`
backup_type=`echo $line | cut -d, -f8`
backup_node=`echo $line | cut -d, -f9`
print_cron_entry  $db_unique_name "sun" $schedule_hr $backup_type $backup_node

#
schedule_day=`echo $line | cut -d, -f10`
schedule_hr=`echo $line | cut -d, -f11`
backup_type=`echo $line | cut -d, -f12`
backup_node=`echo $line | cut -d, -f13`
print_cron_entry  $db_unique_name "mon" $schedule_hr $backup_type $backup_node

#
schedule_day=`echo $line | cut -d, -f14`
schedule_hr=`echo $line | cut -d, -f15`
backup_type=`echo $line | cut -d, -f16`
backup_node=`echo $line | cut -d, -f17`
print_cron_entry  $db_unique_name "tue" $schedule_hr $backup_type $backup_node

#
schedule_day=`echo $line | cut -d, -f18`
schedule_hr=`echo $line | cut -d, -f19`
backup_type=`echo $line | cut -d, -f20`
backup_node=`echo $line | cut -d, -f21`
print_cron_entry  $db_unique_name "wed" $schedule_hr $backup_type $backup_node

#
schedule_day=`echo $line | cut -d, -f22`
schedule_hr=`echo $line | cut -d, -f23`
backup_type=`echo $line | cut -d, -f24`
backup_node=`echo $line | cut -d, -f25`
print_cron_entry  $db_unique_name "thu" $schedule_hr $backup_type $backup_node

#
schedule_day=`echo $line | cut -d, -f26`
schedule_hr=`echo $line | cut -d, -f27`
backup_type=`echo $line | cut -d, -f28`
backup_node=`echo $line | cut -d, -f29`
print_cron_entry  $db_unique_name "fri" $schedule_hr $backup_type $backup_node

#
schedule_day=`echo $line | cut -d, -f30`
schedule_hr=`echo $line | cut -d, -f31`
backup_type=`echo $line | cut -d, -f32`
backup_node=`echo $line | cut -d, -f33`
print_cron_entry  $db_unique_name "sat" $schedule_hr $backup_type $backup_node

done
