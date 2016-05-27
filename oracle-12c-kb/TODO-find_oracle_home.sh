#
# http://www.dba-oracle.com/t_find_oracle_home.htm
#
#
#
# Question:  I wish to display my ORACLE_HOME variable.  How do I find the value of ORACLE_HOME?
#
# Answer:  There are several commands, some internal and some external to Oracle that will find your current ORACLE_HOME.  Within Oracle SQL*Plus, the following SQL command script will display the value of your ORACLE_HOME:
# SQL > var OH varchar2(200);
#
# SQL > EXEC dbms_system.get_env(.ORACLE_HOME., :OH) ;
#
# SQL > PRINT OH
#
# There are also external commands that show the current settings for the ORACLE_HOME variable.
#
# On most UNIX distributions (AIX, Solaris Linux and HP/UX) you can use the env and echo commands to find the current setting for your ORACLE_HOME. where ORACLE_HOME is set-up as an environmental variable.
#
# $ env|grep -i ORACLE_HOME
#
# /u01/app/oracle/product/10gR2/db_1
#
# $ echo ORACLE_HOME
#
# /u01/app/oracle/product/10gR2/db_1
#
# For other OS environments there ORACLE_HOME is not defined as a variable, you can find the ORACLE_HOME directory with these command sets:
#
# AIX: Display ORACLE_HOME
#
# $ ps -ef | grep pmon
#
# ora1024   262366        1   0   Mar 23      -  0:12 ora_pmon_mysid
#
# ORACLE_SID is mysid
#
# $ ls -l /proc/262366/cwd
#
# lr-x------   2 ora1024  dba  0 Mar 23 19:31 cwd -> /data/opt/app/product/10.2.0.4/db_1/dbs/
#
# ORACLE_HOME is /data/opt/app/product/10.2.0.4/db_1
#
#
#
# Linux & Solaris:Display ORACLE_HOME
#
# $ pgrep  -lf _pmon_
#
# 12546 ora_pmon_mysid
#
# ORACLE_SID is mysid
#
# $ pwdx 12546
#
# 12586: /u01/oracle/10.2.0.4/ee1/dbs
#
# HP/UX: Display ORACLE_HOME
#
#
# $ ps -ef | grep pmon
#
# ora1024 25441     1  0  Mar 21  ?         0:24 ora_pmon_itanic10
#
# ORACLE_SID is itanic10
#
# $ pfiles 25441 | grep  bin
#
# 25441:                  /opt/ora/app/db_1/bin/oracle
#
# ORACLE_HOME is /opt/ora/app/db_1
#
#
# USE SRVCTL
#-----------
#
#
# srvctl config database -d DB_UNIQUE_NAME | grep -i "oracle home"
