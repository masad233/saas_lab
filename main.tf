module "mc-transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.1.6"
  # insert the 3 required variables here
  cloud                  = "AWS"
  region                 = "us-east-1"
  cidr                   = "10.100.10.0/23"
  account                = "AWS"
  enable_segmentation    = true
  enable_transit_firenet = true
  gw_name                = "AWS-Transit"
  ha_gw                  = false
  local_as_number        = 65100
  name                   = "vpc-saas-transit"
}
module "firenet_1" {
  source  = "terraform-aviatrix-modules/mc-firenet/aviatrix"
  version = "v1.1.2"

  transit_module = module.mc-transit
  firewall_image = "Palo Alto Networks VM-Series Next-Generation Firewall (BYOL)"

}

module "mc_cust_A_Landing_spoke" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.2.4"
  # insert the 4 required variables here
  cloud          = "AWS"
  name           = "cust-A-Landing"
  region         = "us-east-1"
  cidr           = "10.200.10.0/24"
  account        = "AWS"
  transit_gw     = module.mc-transit.transit_gateway.gw_name
  gw_name        = "cust-A-Landing-spoke"
  ha_gw          = false
  network_domain = aviatrix_segmentation_network_domain.customer_a.domain_name
}
module "mc_cust_B_Landing_spoke" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.2.4"
  # insert the 4 required variables here
  cloud          = "AWS"
  name           = "cust-B-Landing"
  region         = "us-east-1"
  cidr           = "10.200.20.0/24"
  account        = "AWS"
  transit_gw     = module.mc-transit.transit_gateway.gw_name
  gw_name        = "cust-B-Landing-spoke"
  ha_gw          = false
  network_domain = aviatrix_segmentation_network_domain.customer_b.domain_name
}

module "mc_cust_A_spoke_VPC" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.2.4"
  # insert the 4 required variables here
  cloud          = "AWS"
  name           = "cust-A-VPC"
  region         = "us-east-1"
  cidr           = "10.10.2.0/23"
  account        = "AWS"
  transit_gw     = module.mc-transit.transit_gateway.gw_name
  gw_name        = "cust-A-spoke-VPC"
  ha_gw          = false
  network_domain = aviatrix_segmentation_network_domain.customer_a.domain_name
}
module "mc_cust_B_spoke_VPC" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.2.4"
  # insert the 4 required variables here
  cloud          = "AWS"
  name           = "cust-B-VPC"
  region         = "us-east-1"
  cidr           = "10.10.4.0/23"
  account        = "AWS"
  transit_gw     = module.mc-transit.transit_gateway.gw_name
  gw_name        = "cust-B-spoke-VPC"
  ha_gw          = false
  network_domain = aviatrix_segmentation_network_domain.customer_b.domain_name
}
module "mc_shared_spoke_VPC" {
  source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
  version = "1.2.4"
  # insert the 4 required variables here
  cloud          = "AWS"
  name           = "shared-VPC"
  region         = "us-east-1"
  cidr           = "10.10.0.0/23"
  account        = "AWS"
  transit_gw     = module.mc-transit.transit_gateway.gw_name
  gw_name        = "shared-spoke-VPC"
  ha_gw          = false
  network_domain = aviatrix_segmentation_network_domain.shared.domain_name
}
# module "mc_cus_a_site" {
#   source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
#   version = "1.2.4"
#   # insert the 4 required variables here
#   cloud    = "AWS"
#   name     = "cus-a-site"
#   region   = "us-east-2"
#   cidr     = "10.10.1.0/24"
#   account  = "AWS"
#   gw_name  = "cus-a-site"
#   attached = false
#   ha_gw    = false
# }
# module "mc_cus_b_site" {
#   source  = "terraform-aviatrix-modules/mc-spoke/aviatrix"
#   version = "1.2.4"
#   # insert the 4 required variables here
#   cloud    = "AWS"
#   name     = "cus-b-site"
#   region   = "us-east-2"
#   cidr     = "10.10.1.0/24"
#   account  = "AWS"
#   gw_name  = "cus-b-site"
#   attached = false
#   ha_gw    = false
# }
# resource "aviatrix_gateway" "cus_a_site" {
#   cloud_type   = 1
#   account_name = "AWS"
#   gw_name      = "cus-a-site"
#   vpc_id       = "cus-a-site"
#   vpc_reg      = "us-west-1"
#   gw_size      = "t2.micro"
#   subnet       = "10.0.0.0/24"
#   tags         = {
#     name = "value"
#   }
# }
module "cus_a_site" {
  source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
  version = "1.0.4"
  # insert the 4 required variables here
cloud	= "AWS"
name	= "cus-a-site"
region	= "us-east-2"
cidr	= "10.10.1.0/24"
account	= "AWS"
}

module "cus_b_site" {
  source  = "terraform-aviatrix-modules/mc-gateway/aviatrix"
  version = "1.0.4"
  # insert the 4 required variables here
cloud	= "AWS"
name	= "cus-b-site"
region	= "us-east-2"
cidr	= "10.10.1.0/24"
account	= "AWS"
}
module "cus_a_VM" {
source = "./aws-linux-vm-public"
  vm_name = "cus-a-site-vm"
  key_name = "lab-keypair-us-east2"
  vpc_id = module.cus_a_site.vpc.vpc_id
  subnet_id = module.cus_a_site.vpc.public_subnets[0].subnet_id
}
module "cus_b_VM" {
source = "./aws-linux-vm-public"
  vm_name = "cus-b-site-vm"
  key_name = "lab-keypair-us-east2"
  vpc_id = module.cus_b_site.vpc.vpc_id
  subnet_id = module.cus_b_site.vpc.public_subnets[0].subnet_id
}
