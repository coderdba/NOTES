# Create network
resource "openstack_networking_network_v2" "nw1001_1" {
  name           = "nw1001_1"
  admin_state_up = "true"
}

# Create subnet
resource "openstack_networking_subnet_v2" "sn1001_1" {
  name       = "sn1001_1"
  network_id = "${openstack_networking_network_v2.nw1001_1.id}"
  cidr       = "192.168.20.0/24"
  ip_version = 4
}

# Create router AND attach it to an External Network
# Note: This 'gateway' is the UUID of the VLAN to which to connect
resource "openstack_networking_router_v2" "rr1001_1" {
  name             = "rr1001_1"
  #external_gateway = "ext_vlan1001_net"
  external_gateway = "dsfsdf098-86f9-428e-b462-dsfsdf0"
}

# Attach router to internal network (subnet)
resource "openstack_networking_router_interface_v2" "rr1001_1_interfaces" {
  router_id = "${openstack_networking_router_v2.rr1001_1.id}"
  subnet_id = "${openstack_networking_subnet_v2.sn1001_1.id}"
}
