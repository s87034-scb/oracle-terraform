variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "ssh_instance_public_key" {}
variable "vcn_cidr_block" {
  default = "10.0.0.0/16"
}
variable "vcn_public_sunet" {
  default = "10.0.1.0/24"
}
variable "vcn_private_subnet" {
  default = "10.0.2.0/24"
}

variable limit {
  default = "20"
}

variable timeout {
  default = "30m"
}
variable "customer" {
  default = "scbdta"
}

variable "region_label" {
  type = string
  default = "SGP"
}

variable "instance_shape" {
  default = "VM.Standard.E4.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "instance_shape_memory" {
  default = 1
}

variable "instance_image_ocid" {
  type = map(string)
  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    # Oracle-provided image "Oracle-Linux-7.9-2022.04.26-0"
    ap-singapore-1 = "ocid1.image.oc1.ap-singapore-1.aaaaaaaa6yqva3rg7f3zuk4semo2eckp4yzisqiqaapc4xqzoarcocvzm77q"
  }
}

