echo Starting `date`
echo Setting environment

export VERSION=0.0.1
#export PACKER_LOG_PATH=/dev/stderr 
export PACKER_LOG_PATH=/dev/stdout 
export PACKER_LOG=1 
export PACKER_CACHE_DIR=/data/packer_cache 

echo Starting packer command

/data/bin/packer build derive1-packer.json
#/data/bin/packer build -machine-readable derive1-packer.json

echo Packer command completed

echo Moving new image to /data/images
/bin/mv img/centos7 /data/images/centos7-gm0-derive1-${VERSION}.qcow2

echo Removing the temporary folder img
rmdir img

echo Ending `date`
