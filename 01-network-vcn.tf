# -----------------------------------------------------------------------------
# Create VCN
# -----------------------------------------------------------------------------
resource "oci_core_vcn" "vcn" {
    cidr_block    = var.vcn_cidr_block
    dns_label      = "vcn"
    compartment_id = var.compartment_ocid
    display_name   = "OCI-${var.customer}-VCN-${var.region_label}"
}

# -----------------------------------------------------------------------------
# Create public subnet 
# -----------------------------------------------------------------------------
resource "oci_core_subnet" "pub_subnet" {
    cidr_block                 = var.vcn_public_sunet
    display_name               = "OCI-${var.customer}-PUB-SUB-${var.region_label}"
    dns_label                  = "pub"
    compartment_id             = var.compartment_ocid
    vcn_id                     = oci_core_vcn.vcn.id
    route_table_id             = oci_core_default_route_table.default_route_table.id
    #route_table_id             = oci_core_route_table.public_route_table.id
    prohibit_public_ip_on_vnic = false
    security_list_ids = [oci_core_security_list.public_security_list.id]
}

# -----------------------------------------------------------------------------
# Create private subnet 
# -----------------------------------------------------------------------------
resource "oci_core_subnet" "pri_subnet" {
    cidr_block                 = var.vcn_private_subnet
    display_name               = "OCI-${var.customer}-PRI-SUB-${var.region_label}"
    dns_label                  = "priv"
    compartment_id             = var.compartment_ocid
    vcn_id                     = oci_core_vcn.vcn.id
    route_table_id             = oci_core_route_table.workload_nat_route_table.id
    prohibit_public_ip_on_vnic = true
    security_list_ids = [oci_core_security_list.private_security_list.id]
}

# -----------------------------------------------------------------------------
# Create default route table for routing public workload subnets to Internet Gateway
# -----------------------------------------------------------------------------
resource "oci_core_default_route_table" "default_route_table" {
    manage_default_resource_id = oci_core_vcn.vcn.default_route_table_id
    display_name               = "defaultRouteTable-${var.region_label}"

    route_rules {
      destination       = "0.0.0.0/0"
      destination_type  = "CIDR_BLOCK"
      network_entity_id = oci_core_internet_gateway.internet_gateway.id
    }
}

# -----------------------------------------------------------------------------
# Create route table for routing private workload subnets to NAT Gateway
# -----------------------------------------------------------------------------
resource "oci_core_route_table" "workload_nat_route_table" {
  compartment_id = var.compartment_ocid
  display_name   = "OCI-${var.customer}-PRI-ROUTE-${var.region_label}"
  vcn_id         = oci_core_vcn.vcn.id

  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.nat_gateway.id
  }

  route_rules {
    destination_type  = "SERVICE_CIDR_BLOCK"
    destination       = lookup(data.oci_core_services.service_gateway_all_oci_services.services[0], "cidr_block")
    network_entity_id = oci_core_service_gateway.service_gateway.id
  }
}

# -----------------------------------------------------------------------------
# Create Internet Gateway
# -----------------------------------------------------------------------------
resource "oci_core_internet_gateway" "internet_gateway" {
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn.id
    enabled = true
    display_name = "OCI-${var.customer}-IGW-${var.region_label}"

}

# -----------------------------------------------------------------------------
# Create NAT Gateway
# -----------------------------------------------------------------------------
resource "oci_core_nat_gateway" "nat_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "OCI-VCN-NGW-${var.region_label}"
  vcn_id         = oci_core_vcn.vcn.id
}

# -----------------------------------------------------------------------------
# Create service gateway
# -----------------------------------------------------------------------------
resource "oci_core_service_gateway" "service_gateway" {
  compartment_id = var.compartment_ocid
  display_name   = "OCI-VCN-SGW-${var.region_label}"
  vcn_id         = oci_core_vcn.vcn.id
  services {
    service_id = lookup(data.oci_core_services.service_gateway_all_oci_services.services[0], "id")
  }
}
