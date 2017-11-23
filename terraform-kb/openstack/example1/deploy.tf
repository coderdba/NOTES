variable "count" {
  default = 1
}

resource "openstack_compute_instance_v2" "redis" {
  count = "${var.count}"
  name = "${format("myvm-%02d", count.index+1)}"
  image_name = "${var.image}"
  #availability_zone = "AZ1"
  #flavor_id = "1"
  flavor_name = "${var.flavor}"
  key_pair = "${var.openstack_keypair}"
  security_groups = ["${var.tenant_security_group}"]
  network {
    #name = "${var.tenant_network}"
    name = "${var.nw1001_1}"
  }
  #user_data = "${file("touch.sh")}"
  user_data = "${file("touch2.sh")}"
}

resource "openstack_networking_floatingip_v2" "fip_1" {
  pool = "ext_vlan1001_net"
}

resource "openstack_compute_floatingip_associate_v2" "fip_1" {
  floating_ip = "${openstack_networking_floatingip_v2.fip_1.address}"
  instance_id = "${openstack_compute_instance_v2.redis.id}"
}
