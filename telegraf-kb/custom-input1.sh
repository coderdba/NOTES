#!/bin/bash
# Format : |measurement|,tag_set| |field_set| |timestamp|
# Example:  weather,location=us-midwest,state=mn temperature=82,humidity=71,rain=20 1465839830100400200

time_stamp=`date +%s`
#logfile=/root/telegraf/custom_input1.log
#echo $time_stamp >> $logfile 2>> $logfile

# Note: timestamp is optional
#echo "custom1,cloud_detail=ti-lab-mylocation,custom_tag1=customtag1 value1=1.1,value2=10,value3=200 $time_stamp"
#echo "custom1,cloud_detail=ti-lab-mylocation,custom_tag1=customtag1 value1=1.1 $time_stamp"
#echo "custom1,cloud_detail=ti-lab-mylocation,custom_tag1=customtag1 value2=2.2 $time_stamp"
#echo "custom1,cloud_detail=ti-lab-mylocation,custom_tag1=customtag1 value3=3.3 $time_stamp"

# without timestamp
echo "custom1,cloud_detail=ti-lab-mylocation,custom_tag1=customtag1 value10=1.1,value20=2.2,value30=3.3"
#echo "custom1,cloud_detail=ti-lab-mylocation,custom_tag1=customtag1 value1=1.1"
