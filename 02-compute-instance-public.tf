resource "oci_core_instance" "public_instance" {
    #Required
    availability_domain = data.oci_identity_availability_domain.ad.name
    compartment_id = var.compartment_ocid
    shape = var.instance_shape
    display_name        = "pub-${var.customer}-instance-${var.region_label}"
 
    shape_config {
      ocpus = var.instance_ocpus
      memory_in_gbs = var.instance_shape_memory
  }

    create_vnic_details {
        subnet_id                 = oci_core_subnet.pub_subnet.id
        display_name              = "primarypubvnic"
        assign_public_ip          = true
        assign_private_dns_record = true
        hostname_label            = "pub-${var.customer}instance-${var.region_label}"
    }

    source_details {
        source_type = "image"
        source_id = var.instance_image_ocid[var.region]

    }
    metadata = {
        ssh_authorized_keys = var.ssh_instance_public_key
        # user_data           = base64encode(file("./userdata/bootstrap"))
    }

    timeouts {
        create = var.timeout
    }
    preserve_boot_volume = false
}
