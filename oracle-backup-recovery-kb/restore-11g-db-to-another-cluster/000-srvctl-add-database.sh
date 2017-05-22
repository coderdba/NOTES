# srvctl add database -d db_unique_name -o oracle_home
#      [-x node_name] [-m domain_name] [-p spfile]
#      [-c  {RACONENODE | RAC | SINGLE} [-e server_list] [-i instance_name] [-w timeout]]
#      [-r {PRIMARY | PHYSICAL_STANDBY | LOGICAL_STANDBY | SNAPSHOT_STANDBY}]
#      [-s start_options] [-t stop_options] [-n db_name -j "acfs_path_list"]
#      [-y {AUTOMATIC | MANUAL | NORESTART}] [-g server_pool_list] [-a disk_group_list]

srvctl add database -d DB_UNIQUE_NAME -o /u01/app/oracle/product/11.2.0.4 -c RAC -r PRIMARY -s 'OPEN' -t IMMEDIATE -n DB_NAME
srvctl add instance -d DB_UNIQUE_NAME -i INSTANCE1 -n node1
srvctl add instance -d DB_UNIQUE_NAME -i INSTANCE2 -n node2
