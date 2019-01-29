##
# K8S Core KS for TI
#
# Add this to boot kernel string in grub:
# kernel vmlinuz load_ramdisk=1 initrd=initrd.img ip=<ip>::<gw>:<snm>::<interface>:none inst.ks=http://ttcoscore1-rgw-vip.target.com/swift/v1/k8s-build/ks/<whatever>.ks inst.text inst.gpt nameserver=10.64.40.215

network --hostname=k8master1 --mtu=1500

install
reboot
cdrom

# Base Settings
#
auth --enableshadow --passalgo=sha512
text
keyboard --vckeymap=us --xlayouts='us'
lang en_US.UTF-8
rootpw --iscrypted $6$ftsdfso8s7oisldk$dsf4MFXZMG8KYYVEi55W17M6ivG9YvNDZVtxzgxr3TLy2.56b79j3l/vnOnr7HLki8q/
skipx

timezone US/Central --isUtc --ntpservers=10.100.100.81,10.100.100.85,10.100.100.153,10.100.100.157
selinux --disabled
firewall --disabled
services --enabled=ntpd

# Remove Existing Partitions
#
ignoredisk --only-use=sda
bootloader --location=mbr --driveorder="sda" --boot-drive=sda
zerombr
clearpart --all --initlabel --drives=sda

# Partition Disk
#
part biosboot --size=1
part /boot --fstype="ext4" --ondisk=sda --size=1024
part pv.74 --fstype="lvmpv" --ondisk=sda --size=1 --grow

# Create VG
#
volgroup rootvg --pesize=32768 pv.74

# Create LVs
#
logvol / --fstype="ext4" --size=16384 --name=vol_root --vgname=rootvg
logvol /tmp --fstype="ext4" --size=10240 --name=vol_tmp --vgname=rootvg
logvol /var --fstype="ext4" --size=12288 --name=vol_var --vgname=rootvg
logvol /var/log --fstype="ext4" --size=12288 --name=vol_log --vgname=rootvg
logvol /var/lib --fstype="ext4" --size=204800 --name=vol_lib --vgname=rootvg
logvol swap --fstype="swap" --size=16384 --name=vol_swap --vgname=rootvg
logvol /export/home --fstype="ext4" --size=6144 --name=vol_home --vgname=rootvg

# Package Selection
#
%packages --ignoremissing
@core --nodefaults
bind-utils
kexec-tools
lsof
pcre
snappy
wget
yum
yum-utils
ntp
sysstat
ipmitool
libguestfs
ca-certificates
openssl-devel
openssl-libs
zlib
zlib-devel
bzip2
mlocate
numad
tmux
systemd-libs
net-tools
git

-aic94xx-firmware
-alsa*
-atmel-firmware
-b43-openfwwf
-bfa-firmware
-ipw*firmware
-ivtv-firmware
-iwl*firmware
-libertas*firmware
-ql*firmware
-rt61pci-firmware
-rt73usb-firmware
-xorg-x11-drv-ati-firmware
-zd1211-firmware
-postfix
-plymouth
%end

# POST Config
%post
exec < /dev/tty3 > /dev/tty3
/usr/bin/chvt 3

echo '+########## POST CONFIG ##########+'
echo ' '
echo '###############################'
echo '# Add Custom MOTD'
echo '#'
echo ' '

curl -k http://banners.company.com/sshbanner.txt > /etc/motd

echo ' 'n
echo '###############################'
echo '# Remove Undesired RPMs'
echo '#'
echo ' '

rpm -qa | grep -i networkmanager | xargs rpm -e
rpm -qa | grep -i chrony | xargs rpm -e

echo ' 'n
echo '###############################'
echo '# Install node_exporter'
echo '#'
echo ' '

curl -k http://rpms.company.com/node-exporter-0.14.1-1.x86_64.rpm > /tmp/node_exporter.rpm
rpm -i /tmp/node_exporter.rpm

echo ' '
echo '###############################'
echo '# Add EZRepos'
echo '#'
echo ' '

rm -f /etc/yum.repos.d/*
curl -k http://repos.company.com/k8s-ezrepo-centos.repo > /etc/yum.repos.d/cent7.repo
yum -q clean all
echo 'Installed Repos: '
yum repolist all

echo ' '
echo '###############################'
echo '# Full OS Update'
echo '#'
echo ' '

sleep 5
yum -y -q update

echo ' '
echo '###############################'
echo '# Inject SSH Key'
echo '#'
echo ' '

mkdir -m0700 /root/.ssh/
cat <<EOF >/root/.ssh/authorized_keys
ssh-rsa AAALKJDFLKDJF89sdufsknkj23+HeZ59EOJpIQFFZVWEVdakCIAv+sRLipQCbiwp8zE7GBIV+RZeE3j7l8oZMEqBMtT3f9oByhGnjr9dSSKJeqcMta2rSE/em8US8upg2hbbyZvZW9lCfcTTwao3ALUmbCmnvJKnWe1ubOYhXqUBYMjEr80yEDdF9YptpNRRa18ZXf8xIUjLwEzHDQPZ9I2Yle+cFu7q3nXrHX2T9SiMaMPT3od7McRIZwCO1lE/mtaFB33aECuMjra5nBx6sfbNH+QCAN1tzl9gFnrB1XIY6HXzSiQR0AgeRHdiTsoCHlaxxQqIcHMTRH9J
EOF
chmod 0600 /root/.ssh/authorized_keys

echo ' '
echo "++=============================++"
echo "++===== INSTALL COMPLETE! =====++"
echo "++===== REBOOT IN 30 SEC! =====++"
echo "++=============================++"
sleep 30

%end
