#/bin/bash
#http://dba.stackexchange.com/questions/48173/cannot-start-mysql-cluster-with-single-node
echo "" > mysql_cluster_start_script.log
$HOME/mysqlc/bin/ndb_mgmd -f conf/config.ini --initial --configdir=$HOME/my_cluster/conf/ >> mysql_cluster_start_script.log
$HOME/mysqlc/bin/ndbd -c localhost:1186 >> mysql_cluster_start_script.log
$HOME/mysqlc/bin/ndb_mgm -e show >> mysql_cluster_start_script.log
$HOME/mysqlc/bin/mysqld --defaults-file=conf/my.cnf > mysqld.log 2>&1 &
