# Create a 'basic' security group
# $ openstack security group create BastionSG --description 'Allow SSH and pings'
resource "openstack_networking_secgroup_v2" "TCPin_ssh" {
  name        = "TCPin_ssh"
  description = "Allow SSH and pings"
}

# Allow ssh only from any IP
# $ openstack security group rule create BastionSG --proto tcp --dst-port 22:22
resource "openstack_networking_secgroup_rule_v2" "TCPin_ssh_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.TCPin_ssh.id}"
}

# Allow ping from any IP
# $ openstack security group rule create BastionSG --proto icmp --dst-port -1
resource "openstack_networking_secgroup_rule_v2" "TCPin_ssh_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.TCPin_ssh.id}"
}

#
# NOTE: We can open specific ports PLUS all ports 
#       - just to show distinctly ssh (22), http (80), other like https(443), redis (6379) etc - AND ALL for the same security group
#       OR - Just open all and it will be understood
#
# Create a security group to allow TCP connections on all ports
resource "openstack_networking_secgroup_v2" "TCPin_allports_1" {
  name        = "TCPin_allports_1"
  description = "Allow TCP on all ports"
}

# Allow TCP on all ports from any IP
resource "openstack_networking_secgroup_rule_v2" "TCPin_allports_1_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 1
  port_range_max    = 65535
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.TCPin_allports_1.id}"
}

# Allow ping from any IP
resource "openstack_networking_secgroup_rule_v2" "TCPin_allports_1_rule_2" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${openstack_networking_secgroup_v2.TCPin_allports_1.id}"
}
