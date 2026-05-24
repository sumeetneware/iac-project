terraform {
  required_version = ">= 1.5"

  backend "s3" {
    bucket         = "terraform-state-sumeet-dev-001"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }

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

  vpc_cidr              = "10.0.0.0/16"
  public_subnet_cidr    = "10.0.1.0/24"
  private_subnet_cidr   = "10.0.4.0/24"
  private_subnet_2_cidr = "10.0.5.0/24"
}



module "compute" {
  source = "../../modules/compute"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.public_subnet_id

  instance_type = "t3.micro"

  ami_id = "ami-0f58b397bc5c1f2e8"
}



module "storage" {
  source = "../../modules/storage"

  bucket_name = "iac-project-sumeet-2026"
}



module "database" {
  source = "../../modules/database"

  vpc_id = module.network.vpc_id

  private_subnet_1_id = module.network.private_subnet_1_id
  private_subnet_2_id = module.network.private_subnet_2_id

  db_username = var.db_username
  db_password = var.db_password
}