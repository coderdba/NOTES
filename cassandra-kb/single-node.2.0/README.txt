Highlights:
Mounts a host volume to the container - for Cassandra to store data on host and be stateless to an extent
Prerequisite - create the host volume/folder - see runwithportvol.sh for the folder to create (and docker-entrypoint.sh)

Usage:
Copy all these files to a folder
Run build.sh to build an image
Run runwithportvol.sh to create a container as daemon using the image
--> note that this has a command to do 'tail -f /dev/null' so that that process is continuously running 
    - otherwise container exits upon completion of docker-entrypoint.sh

Use porthostopen.sh to open host's port so that someone can connect to the container from outside of this host
Use bashgo.sh to get into the container using bash
Use cqlshx.sh to get into the container using cqlsh

Enhancement to do:
Make the container fully stateless:
  Store config yaml files on host
  Store other files in /var/lib/cassandra also on the host 
