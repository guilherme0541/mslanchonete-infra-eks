data "aws_availability_zones" "available" {}

locals {
  vpc_name = "${var.project_name}-vpc"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc_name
  cidr = local.vpc_cidr

  azs = local.azs

  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  private_subnet_tags = {
    type = "private"
  }

  public_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k + 2)]
  public_subnet_tags = {
    type = "public"
  }

  enable_nat_gateway = true

  tags = {
    Name = local.vpc_name
  }
}