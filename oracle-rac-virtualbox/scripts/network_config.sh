#-- Private
ifdown enp0s8
ifconfig enp0s8 10.10.10.101 netmask 255.255.255.0
ifup enp0s8
ifconfig -a enp0s8

#-- Public
ifdown enp0s9
ifconfig enp0s9 192.168.0.101 netmask 255.255.255.0
ifup enp0s9
ifconfig -a enp0s9
