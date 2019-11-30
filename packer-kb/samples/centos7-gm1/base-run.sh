echo Starting `date`
echo Setting environment

export VERSION=0.0.1
#export PACKER_LOG_PATH=/dev/stderr 
export PACKER_LOG_PATH=/dev/stdout 
export PACKER_LOG=1 
export PACKER_CACHE_DIR=/var/lib/packer-work/packer_cache 

echo Starting packer command

#/data/bin/packer build base-packer.json
#/data/bin/packer build -machine-readable base-packer.json

/root/packer/packer build -var 'rpm=true' base-packer.json

echo Packer command completed

echo Moving new image to /data/images
/bin/mv img/centos7 /var/lib/packer-work/images/centos7-gm1-base-${VERSION}.qcow2

echo Removing the temporary folder img
rmdir img

echo Ending `date`
