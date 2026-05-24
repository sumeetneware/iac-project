terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


module "network" {
  source = "../../modules/network"

  vpc_cidr            = "10.0.0.0/16"
  public_subnet_cidr  = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
}



module "compute" {
  source = "../../modules/compute"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_id

  instance_type = "t3.micro"

  ami_id = "ami-0f58b397bc5c1f2e8"
}