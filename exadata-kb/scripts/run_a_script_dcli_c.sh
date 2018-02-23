if [ $# -lt 2 ]
then

echo 
echo Usage: $0 machine_to_run_on script_local_path
echo
exit 1

fi

machine=$1
script=$2
script_basename=`basename $2`

remotedir=/root/tmp_${script_basename}_run

echo INFO - Creating $remotedir on $machine
dcli -c $machine -l root "mkdir -p $remotedir"

echo INFO - Copying $script_basename to $machine:$remotedir
scp -q $script ${machine}:${remotedir}/.

dcli -c $machine -l root "chmod 700 ${remotedir}/${script_basename}; ${remotedir}/${script_basename}; rm -rf $remotedir"
