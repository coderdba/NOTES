resource "openstack_compute_floatingip_v2" "floatip_1" {
  pool = "ext_vlan1773_net"
}
