dcli -c $1 -l root 'export ORAENV_ASK=NO; export sid=`grep ASM /etc/oratab | cut -d: -f1`; export ORACLE_SID="$sid"; . oraenv; crsctl stat res -t'
