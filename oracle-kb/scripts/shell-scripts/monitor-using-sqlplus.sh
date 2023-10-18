export PATH=$PATH:/root/oracle/instantclient_21_11
export LD_LIBRARY_PATH=/root/oracle/instantclient_21_11

sqlplus -s /nolog <<EOF

connect monuser/password@192.168.29.197:1521/XEPDB1
select sysdate from dual;

EOF
