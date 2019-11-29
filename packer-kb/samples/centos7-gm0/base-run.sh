echo Starting `date`
echo Setting environment

export VERSION=0.0.1
export PACKER_LOG_PATH=/dev/stderr 
export PACKER_LOG=1 
export PACKER_CACHE_DIR=/data/packer_cache 

echo Starting packer command

/data/bin/packer build -var 'provisioner=provisionerless' -var 'rpm=true' base-packer.json

echo Packer command completed

echo Moving new image to /data/images
mv img/centos7 /data/images/centos7-gm0-base-${VERSION}.qcow2

echo Removing the temporary folder centos7-base-img
rmdir img

echo Ending `date`
