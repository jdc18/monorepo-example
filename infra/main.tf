terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
    vercel = {
      source  = "vercel/vercel"
      version = "~> 0.4"
    }
  }
  backend "s3" {
    bucket               = "myproject-infra-remote-storage"
    workspace_key_prefix = "environments"
    key                  = "frontend/terraform.tfstate"
    region               = "us-east-1"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "Terraform"
      Environment = terraform.workspace
    }
  }
}

locals {
  production_availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_name}-vpc-${terraform.workspace}"
  cidr = var.vpc_cidr

  azs             = local.production_availability_zones
  private_subnets = var.public_subnets_cidr
  public_subnets  = var.private_subnets_cidr

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

}
