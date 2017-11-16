- VIEW A PLAN
$ terraform plan

- RUN TO CREATE STUFF
$ terraform apply
openstack_compute_instance_v2.redis: Creating...
  access_ip_v4:               "" => "<computed>"
  access_ip_v6:               "" => "<computed>"
  all_metadata.%:             "" => "<computed>"
  availability_zone:          "" => "<computed>"
  flavor_id:                  "" => "<computed>"
  flavor_name:                "" => "smem-2vcpu"
  force_delete:               "" => "false"
  image_id:                   "" => "<computed>"
  image_name:                 "" => "redis_ubuntu_2instance_dbpot"
  key_pair:                   "" => "MySshKey"
  name:                       "" => "redistf-01"
  network.#:                  "" => "1"
  network.0.access_network:   "" => "false"
  network.0.fixed_ip_v4:      "" => "<computed>"
  network.0.fixed_ip_v6:      "" => "<computed>"
  network.0.floating_ip:      "" => "<computed>"
  network.0.mac:              "" => "<computed>"
  network.0.name:             "" => "MyNetwork"
  network.0.port:             "" => "<computed>"
  network.0.uuid:             "" => "<computed>"
  region:                     "" => "<computed>"
  security_groups.#:          "" => "1"
  security_groups.3773427488: "" => "TCPExternalSG"
  stop_before_destroy:        "" => "false"
  user_data:                  "" => "1502ba977f55d49e2f93de66b19734589fb51f2e"
openstack_compute_instance_v2.redis: Still creating... (10s elapsed)
openstack_compute_instance_v2.redis: Still creating... (20s elapsed)
openstack_compute_instance_v2.redis: Still creating... (30s elapsed)
openstack_compute_instance_v2.redis: Still creating... (40s elapsed)
openstack_compute_instance_v2.redis: Still creating... (50s elapsed)
openstack_compute_instance_v2.redis: Still creating... (1m0s elapsed)
openstack_compute_instance_v2.redis: Still creating... (1m10s elapsed)
openstack_compute_instance_v2.redis: Still creating... (1m20s elapsed)
openstack_compute_instance_v2.redis: Still creating... (1m30s elapsed)
openstack_compute_instance_v2.redis: Still creating... (1m40s elapsed)
openstack_compute_instance_v2.redis: Still creating... (1m50s elapsed)
openstack_compute_instance_v2.redis: Still creating... (2m0s elapsed)
openstack_compute_instance_v2.redis: Still creating... (2m10s elapsed)
openstack_compute_instance_v2.redis: Still creating... (2m20s elapsed)
openstack_compute_instance_v2.redis: Still creating... (2m30s elapsed)
openstack_compute_instance_v2.redis: Creation complete after 2m36s (ID: b29140fe-010d-438b-9445-35a7f7aba0ab)

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.


- AFTER ADDING floatipcreate.tf

$ terraform apply
openstack_compute_instance_v2.redis: Refreshing state... (ID: b29140fe-010d-438b-9445-35a7f7aba0ab)
openstack_compute_floatingip_v2.floatip_1: Creating...
  address:     "" => "<computed>"
  fixed_ip:    "" => "<computed>"
  instance_id: "" => "<computed>"
  pool:        "" => "ext_vlanabcd_net"
  region:      "" => "<computed>"
openstack_compute_floatingip_v2.floatip_1: Creation complete after 1s (ID: 90f840b6-31a2-54b8-8862-533133561aba)

