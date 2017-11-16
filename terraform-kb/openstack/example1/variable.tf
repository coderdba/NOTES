variable "flavor" {
default = "smallmemory-2vcpu"
}

variable "image" {
default = "redis_ubuntu_2instance"
}

variable "ssh_user_name" {
default = "ubuntu"
}

variable "openstack_user_name" {
    description = "The username for the Tenant."
    default  = "myusername"
}

variable "openstack_tenant_name" {
    description = "The name of the Tenant."
    default  = "MYTENANT"
}

variable "openstack_password" {
    description = "The password for the Tenant."
    default  = "mypassword"
}

variable "openstack_auth_url" {
    description = "The endpoint url to connect to OpenStack."
    default  = "https://openstack.company.com:5000/v2.0"
}

variable "openstack_keypair" {
    description = "The keypair to be used."
    default  = "MySshKey"
}

variable "tenant_network" {
    description = "The network to be used."
    default  = "MyNetwork"
}

variable "tenant_security_group" {
    description = "The network to be used."
    default  = "TCPExternalSG"
}

variable "ssh_key_file" {
default = "~/.ssh/id_rsa.terraform"
}

#variable "external_gateway" {
#}

variable "pool" {
default = "public"
}
