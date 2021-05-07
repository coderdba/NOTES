===========================
TRACING POSTGRES
===========================

Install Postgres client: https://www.symmcom.com/docs/how-tos/databases/how-to-install-postgresql-11-x-on-centos-7
Install Postgres server: https://www.postgresql.org/download/linux/redhat/

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
