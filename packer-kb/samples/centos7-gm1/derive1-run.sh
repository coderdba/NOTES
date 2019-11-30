echo Starting `date`
echo Setting environment

export VERSION=0.0.1
#export PACKER_LOG_PATH=/dev/stderr 
export PACKER_LOG_PATH=/dev/stdout 
export PACKER_LOG=1 
#export PACKER_CACHE_DIR=/data/packer_cache 
export PACKER_CACHE_DIR=/var/lib/packer-work

echo Starting packer command

/root/packer/packer build derive1-packer.json
#/root/packer/packer build -machine-readable derive1-packer.json

echo Packer command completed

echo Moving new image to /data/images
/bin/mv img/centos7 /var/lib/packer-work/images/centos7-gm1-derive1-${VERSION}.qcow2

echo Removing the temporary folder img
rmdir img

echo Ending `date`
