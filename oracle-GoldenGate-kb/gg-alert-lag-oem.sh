#!/bin/ksh
export scriptpath=$0
export script=`basename $scriptpath`
export scriptdir=`dirname $scriptpath`

export cluster14="adfd1, dfd1"

export host=`hostname -s`
export timestamp=`date`

if  echo $cluster14 | grep $host > /dev/null 2>> /dev/null
then

export ORACLE_BASE=/app/oracle
export ORACLE_HOME=/app/oracle/product/11.2.0.4
export GG_HOME=/app/oracle/product/12.1.2.1.OGG

#echo here1

elif  echo $cluster15 | grep $host > /dev/null 2>> /dev/null
then

export ORACLE_BASE=/app/oracle
export ORACLE_HOME=/app/oracle/product/11.2.0.4
export GG_HOME=/app/oracle/product/12.1.2.1.OGG

elif  echo $cluster15 | grep $host > /dev/null 2>> /dev/null
then

export ORACLE_BASE=/app/oracle
export ORACLE_HOME=/app/oracle/product/11.2.0.4
export GG_HOME=/app/oracle/product/12.1.2.1.OGG

else

export ORACLE_BASE=/opt/oracle
export ORACLE_HOME=/opt/oracle/product/11.2.0.4
export GG_HOME=/opt/oracle/product/12.1.2.1.OGG

#echo here2

fi

export PATH=/bin:/sbin:/etc:/usr/bin:/usr/sbin:/usr/local/bin:/usr/lib:$ORACLE_HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export LIBPATH=$ORACLE_HOME/lib

ggsci=$GG_HOME/ggsci
dirprm=$GG_HOME/dirprm
dirdat=$GG_HOME/dirdat

set_files()
{

#echo here3

scriptpath=$1
script=`basename $scriptpath`
scriptdir=`dirname $scriptpath`
cd $scriptdir
scriptdir=`pwd`
installdir=`dirname $scriptdir`
logdir=${installdir}/log
logfile=${logdir}/${script}.${host}.log
errfile=${logdir}/${script}.${host}.err
oemfile=${logdir}/${script}.${host}.oem
tmpfile1=${logdir}/${script}.${host}.tmp1
tmpfile2=${logdir}/${script}.${host}.tmp2

}

# Set environment end

set_files $scriptpath

cd $GG_HOME

#  Get the list of running processes
> $tmpfile1
$ggsci <<EOF > $tmpfile1 2>> $tmpfile1
info all
EOF

#echo here4
#echo $tmpfile1
#cat $tmpfile1

>$oemfile
>$tmpfile2
grep -i extract  $tmpfile1 | grep -v ABEND | grep -v STOPPED  >> $tmpfile2
grep -i replicat $tmpfile1 | grep -v ABEND | grep -v STOPPED  >> $tmpfile2

#echo here5

#echo $tmpfile2
#cat $tmpfile2

#echo here6

# Get the lag (TBD - need to loop here)
cat $tmpfile2 | while read line
do

#echo here6

ggprocesstype=`echo $line | awk '{print $1}'`
ggprocess=`echo $line | awk '{print $3}'`

# Check if GG process is running on this node or not
# (it may be running on other node, but show up here as directories dirxxx are common in shared folders)

if ( ps -ef |grep PROCESSID | grep $ggprocess | grep -v grep > /dev/null 2>>/dev/null )
then

$ggsci <<EOF > $tmpfile1 2>> $tmpfile1
lag $ggprocesstype $ggprocess
EOF

lag=`grep -i "last record" $tmpfile1 | awk '{print $4}' `
if [ "$lag" == "" ]
then
     lag=0
fi

# This echo is for OEM to trap the lag and send alert/email
#  1. To a file if OEM has to read a file
echo "em_result=${host}-${ggprocesstype}-${ggprocess}|${lag}" >> $oemfile
#  2. To stdout if OEM can run this cript directly
echo "em_result=${host}-${ggprocesstype}-${ggprocess}|${lag}"

# This echo is for running log file to keep historic data
echo "Lag=${timestamp}|${host}-${ggprocesstype}-${ggprocess}|${lag} seconds" >> $logfile

else

echo "INFO - Process $ggprocess is not running on this node $host"

fi

done

#debug with hard-coded messages
#echo "em_result=debugEIGG01|350"
#echo "em_result=debugPIGG01|111"
#echo "em_result=debugRIGG01|0"

# END
