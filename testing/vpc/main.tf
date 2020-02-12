provider "aws" {
  region = "us-east-1"
}

locals {
  cluster_name = "test-eks"
}

module "vpc" {
  source = "../../modules/services/vpc"

  name = "vpc-eks"

  cidr = "10.0.0.0/16"

  azs                 = ["us-east-1a", "us-east-1b"]
  private_subnets     = ["10.0.10.0/24", "10.0.20.0/24"]
  public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  vpc_tags = {
    Name = "vpc-eks"
  }
}
