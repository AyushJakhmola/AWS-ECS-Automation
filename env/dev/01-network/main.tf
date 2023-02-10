module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_az
  private_subnets = var.private_subnets_cidr
  public_subnets  = var.public_subnets_cidr
  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = {
    Environment = "stg"
  }
  private_subnet_tags = {
    Name = "private"
  }
  public_subnet_tags = {
    Name = "public"
  }
}