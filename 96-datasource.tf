data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

data "oci_identity_fault_domains" "fault_domains" {
    #Required
    availability_domain = data.oci_identity_availability_domain.ad.name
    compartment_id = var.compartment_ocid
}

# -----------------------------------------------------------------------------
# Query Service gateway id
# -----------------------------------------------------------------------------
data "oci_core_services" "service_gateway_all_oci_services" {
  filter {
    name   = "name"
    values = ["All [A-Za-z0-9]+ Services In Oracle Services Network"]
    regex  = true
  }
}
