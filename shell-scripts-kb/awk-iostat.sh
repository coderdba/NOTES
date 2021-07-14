#!/bin/bash

# It wont take multiple line ouputs , we need to loop through each line ,echo is splitting the line with first space ,so need to set IFS before echo

now=$(date +%s%N)
iostat_command_file="/tmp/stage_$$.log"
output_file="/tmp/metric-output_$$.log"
sudo /usr/local/bin/dcli -l root -g /root/cell_group "/usr/bin/iostat -t -x -p  -y 1 1" > $iostat_command_file
cat $iostat_command_file |sed 's/:/ /g'|awk '$2 ~ /^sd*/ || $2 ~ /^nv*/ {print "cellserveriostat,cellserver="$1",Device="$2",purpose=measurement rrqm-s="$3",wrqm-s="$4",r-s="$5",w-s="$6",rkB-s="$7",wkB-s="$8",avgrq-sz="$9",avgqu-sz="$10",await="$11",r_await="$12",w_await="$13",svctm="$14",percentage_util="$15""}' > $output_file
IFS=$'\n'
for i in `cat $output_file`
do
echo "$i"
done
wait
rm -r $iostat_command_file
rm -r $output_file
