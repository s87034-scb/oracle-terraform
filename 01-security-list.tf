## Security List for Public Subnet
resource "oci_core_security_list" "public_security_list" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn.id
    display_name = "OCI-SL-PUBLIC-${var.region_label}"

    // allow outbound tcp traffic on all ports
    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol    = "6"
    }

    // allow inbound ssh traffic from a specific port
    ingress_security_rules {
        description = "Allow port TCP SSH"
        protocol  = "6" // tcp
        source    = "0.0.0.0/0"
        stateless = false

        tcp_options {

        // These values correspond to the destination port range.
        min = 22
        max = 22
        }
    }

    // allow inbound rdp traffic from a specific port
    ingress_security_rules {
        description = "Allow port TCP RDP"
        protocol  = "6" // tcp
        source    = "0.0.0.0/0"
        stateless = false

        tcp_options {

        // These values correspond to the destination port range.
        min = 3389
        max = 3389
        }
    }

    // allow inbound icmp traffic of a specific type
    ingress_security_rules {
        description = "Allow ICMP"
        protocol    = 1
        source      = "0.0.0.0/0"
        stateless   = true
    }
}

## Security List for Private Subnet
resource "oci_core_security_list" "private_security_list" {
    #Required
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn.id
    display_name = "OCI-SL-PRIVATE-${var.region_label}"

    // allow outbound tcp traffic on all ports
    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol    = "6"
    }

    // allow inbound ssh traffic from a specific port
    ingress_security_rules {
        description = "Allow port TCP SSH"
        protocol  = "6" // tcp
        source    = "0.0.0.0/0"
        stateless = false

        tcp_options {
        // These values correspond to the destination port range.
        min = 3389
        max = 3389
        }
    }

    // allow inbound icmp traffic of a specific type
    ingress_security_rules {
        description = "Allow ICMP"
        protocol    = 1
        source      = "0.0.0.0/0"
        stateless   = true
    }
}
