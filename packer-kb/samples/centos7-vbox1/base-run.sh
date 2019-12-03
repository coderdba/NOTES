echo Starting `date`
echo Setting environment

export VERSION=0.0.1
export PACKER_LOG_PATH=/dev/stderr 
export PACKER_LOG=1 
export PACKER_CACHE_DIR=/Users/username/packer-images

echo Starting packer command

packer build -var 'provisioner=provisionerless' -var 'rpm=true' base-packer.json

echo Packer command completed

#echo Moving new image to /data/images
#mv /Users/username/packer-images/centos7 /Users/username/packer-images/centos7-gm0-base-${VERSION}.qcow2

#echo Removing the temporary folder centos7-base-img
#rmdir img

echo Ending `date`
