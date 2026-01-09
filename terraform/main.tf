terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # CHANGED: Changed from "~> 5.0" to ">= 5.0" to allow version 6.x
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# 1. Create a VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  # ADDED: Pinning version to ensure stability
  version = "5.5.1" 

  name = "devops-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true
}

# 2. Create EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  # ADDED: Pinning version to ensure stability
  version = "~> 20.0"

  cluster_name    = "devops-cluster"
  cluster_version = "1.29"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access = true

  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["t3.micro"]
    }
  }

  enable_cluster_creator_admin_permissions = true
}

# 3. Create Image Repository
resource "aws_ecr_repository" "app_repo" {
  name         = "devops-app-repo"
  force_delete = true
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "ecr_url" {
  value = aws_ecr_repository.app_repo.repository_url
}	