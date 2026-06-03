module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.34"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_public_access            = true
  enable_cluster_creator_admin_permissions  = true

  eks_managed_node_group_defaults = {
    ami_type       = "AL2023_x86_64_STANDARD"
    instance_types = ["t3.medium"]
    disk_size      = 50
  }

  eks_managed_node_groups = {

    ng_cpu = {
      name = "ng-cpu"

      min_size     = 2
      max_size     = 10
      desired_size = 2

      instance_types = ["t3.medium"]

      labels = {
        workload = "cpu"
      }

      taints = []
    }

    ng_gpu = {
      name = "ng-gpu"

      min_size     = 0
      max_size     = 5
      desired_size = 0

      ami_type = "AL2023_x86_64_NVIDIA"

      instance_types = ["g4dn5.xlarge"]

      labels = {
        workload = "gpu"
        accelerator = "nvidia"
      }

      taints = {
        gpu = {
          key    = "nvidia.com/gpu"
          value  = "true"
          effect = "NO_SCHEDULE"
        }
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
