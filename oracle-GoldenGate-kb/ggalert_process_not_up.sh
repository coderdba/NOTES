#!/bin/ksh
#-------------------------------------------------------
#
#  ggalerts_process_not_up.sh
#
#  With a flag for OEM to search in metric extension
#  Generic - in the sense that it picks up running
#            processes in GG by itself and finds their lags
#
#
#
#Program     Status      Group       Lag at Chkpt  Time Since Chkpt
#
#MANAGER     RUNNING
#REPLICAT    RUNNING     RIODS01     00:00:00      00:00:01
#REPLICAT    RUNNING     RIODS02     00:00:00      00:00:01
#
#-------------------------------------------------------

export scriptpath=$0
export script=`basename $scriptpath`
export scriptdir=`dirname $scriptpath`


# Set environment  begin

export cluster14="dfsdfs1, dsfsdf0"

export host=`hostname -s`
export timestamp=`date`

export ORACLE_BASE=/app/oracle
export ORACLE_HOME=/app/oracle/product/11.2.0.4
export GG_HOME=/app/oracle/product/12.1.2.1.OGG

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
$ggsci <<EOF > $tmpfile1 2>> $tmpfile1
info all
EOF


>$tmpfile2

# Grep NOT-RUNNING processes
grep -i manager  $tmpfile1 | grep -v -i RUNNING    >> $tmpfile2
grep -i extract  $tmpfile1 | grep -v -i RUNNING    >> $tmpfile2
grep -i replicat $tmpfile1 | grep -v -i RUNNING    >> $tmpfile2


>$oemfile
cat $tmpfile2 | grep -v -i ggsci |  while read line
do

process_type=`echo $line | awk '{print $1}'`

if [ "$process_type" == "MANAGER" ]
then
      process_name=""
      process_status=`echo $line |awk '{print $2}'`
else
      process_name=`echo $line |awk '{print $3}'`
      process_status=`echo $line |awk '{print $2}'`
fi


# This echo is for OEM to trap the lag and send alert/email
#  1. To a file if OEM has to read a file
echo "em_result=${host}-${process_type}-${process_name}|CRIT-${process_status}" >> $oemfile
#  2. To stdout if OEM can run this cript directly
echo "em_result=${host}-${process_type}-${process_name}|CRIT-${process_status}"

done

#debug with hard-coded messages
#echo "em_result=debugEIGG01|ABEND"
#echo "em_result=debugPIGG01|STOPPED"
#echo "em_result=debugRIGG01|ABEND"

# END
