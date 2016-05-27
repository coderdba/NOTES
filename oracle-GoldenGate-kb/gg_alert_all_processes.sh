#!/bin/ksh
#-------------------------------------------------------
#
#  ggalerts_lag_oem_generic.sh
#
#  With a flag for OEM to search in metric extension
#  Generic - in the sense that it picks up running
#            processes in GG by itself and finds their lags
#
#
#-------------------------------------------------------

export scriptpath=$0
export script=`basename $scriptpath`
export scriptdir=`dirname $scriptpath`

# Set environment  begin

# Some clusters may have different folder structure, note them here for if-then-else later
export cluster14="x-yabc1,p-qrs1"

export host=`hostname -s`

export ORACLE_BASE=/app/oracle
export ORACLE_HOME=/app/oracle/product/11.2.0.4
export GG_HOME=/app/oracle/product/12.1.2.1.OGG
export ORACLE_SID=RACPROD011


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
logdir=${installdir}
logfile=${logdir}/${script}.log
tmpfile1=${logdir}/${script}.tmp1
tmpfile2=${logdir}/${script}.tmp2

}

# Set environment end

set_files $scriptpath

cd $GG_HOME

#  Get the list of running processes
$ggsci <<EOF > $tmpfile1 2>> $tmpfile1

info all

EOF

#echo here4
#echo $tmpfile1
#cat $tmpfile1

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

$ggsci <<EOF > $tmpfile1 2>> $tmpfile1

lag $ggprocesstype $ggprocess

EOF

lag=`grep -i "last record" $tmpfile1 | awk '{print $4}' `

# This echo is for OEM to trap the lag and send alert/email
echo "em_result=${host}-${ggprocesstype}-${ggprocess}|${lag}"

done

#debug with hard-coded messages
#echo "em_result=hostEI01|350"
#echo "em_result=hostPI01|111"
#echo "em_result=hostRI01|0"

# END
