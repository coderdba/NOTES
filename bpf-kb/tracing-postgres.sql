===========================
TRACING POSTGRES
===========================

Install Postgres client: https://www.symmcom.com/docs/how-tos/databases/how-to-install-postgresql-11-x-on-centos-7
Install Postgres server: https://www.postgresql.org/download/linux/redhat/
Connect to postgres: https://www.enterprisedb.com/postgres-tutorials/connecting-postgresql-using-psql-and-pgadmin

=====================================
SETUP BPF2 MACHINE AS POSTGRES CLIENT
=====================================

- Install the repository RPM:
sudo yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm

- Install postgres client
# yum install postgresql11
# which psql
/usr/bin/psql

- DONT DO on bpf machine: Install PostgreSQL: --> DONT DO THIS - THIS WILL INSTALL SERVER - WE NEED ONLY CLIENT
    sudo yum install -y postgresql11-server

    # Optionally initialize the database and enable automatic start:
    sudo /usr/pgsql-11/bin/postgresql-11-setup initdb
    sudo systemctl enable postgresql-11
    sudo systemctl start postgresql-11
    
- CONNECT TO THE POSTGRES DB ON PG VM
Reference: https://www.enterprisedb.com/postgres-tutorials/connecting-postgresql-using-psql-and-pgadmin
bash-4.2$ psql -h <hostname or ip address> -p <port number of remote machine> -d <database name which you want to connect> -U <username of the database server>

# psql -U postgres -h 192.168.40.161   (defaults to port 5432)
Password for user postgres: P13
postgres=#
postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges   
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | 
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 testdb    | testuser | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =Tc/testuser         +
           |          |          |             |             | testuser=CTc/testuser
(4 rows)

