module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name  = local.name
  kubernetes_version    = "1.31"
  endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

   eks_managed_node_groups = {
    cluster-ng= {
        cluster_addons = {
            vpc-cni=  {
                most_recent_version = true
        }
        kube-proxy=  {
                most_recent_version = true
        }
        coredns=  {
                most_recent_version = true
        }
        }
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2

      capacity_type = "SPOT"
    }
  }

   tags = {
    Environment = local.env
    Terraform   = "true"
  }
}