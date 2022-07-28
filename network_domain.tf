resource "aviatrix_segmentation_network_domain" "customer_a" {
  domain_name = "Customer-A"
}
resource "aviatrix_segmentation_network_domain" "customer_b" {
  domain_name = "Customer-B"
}
resource "aviatrix_segmentation_network_domain" "shared" {
  domain_name = "Shared-Services"
}

resource "aviatrix_segmentation_network_domain_connection_policy" "c_a_to_shared" {
  domain_name_1 = aviatrix_segmentation_network_domain.customer_a.domain_name
  domain_name_2 = aviatrix_segmentation_network_domain.shared.domain_name
}
resource "aviatrix_segmentation_network_domain_connection_policy" "c_b_to_shared" {
  domain_name_1 = aviatrix_segmentation_network_domain.customer_b.domain_name
  domain_name_2 = aviatrix_segmentation_network_domain.shared.domain_name
}