module "mc-transit" {
  source  = "terraform-aviatrix-modules/mc-transit/aviatrix"
  version = "2.1.6"
  # insert the 3 required variables here
  cloud = "AWS"
  region = "us-east-1"
  cidr = "10.100.10.0/23"
  account = "AWS"
  enable_segmentation = true
  enable_transit_firenet = true
  gw_name = "AWS-Transit"
  ha_gw = false
  local_as_number = 65100
  name = "vpc-saas-transit"
}