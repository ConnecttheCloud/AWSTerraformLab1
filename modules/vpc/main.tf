module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "NYP-${var.infra_env}-vpc"
  cidr = var.vpc_cidr

  azs                  = var.azs
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  public_subnet_names  = var.public_subnet_names
  private_subnet_names = var.private_subnet_names
  ## this attribute map subnet to assign auto public ip address
  map_public_ip_on_launch = true
  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  # manage_default_network_acl    = false
  # manage_default_route_table    = false
  # manage_default_security_group = false

  tags = var.additional_tags

}
