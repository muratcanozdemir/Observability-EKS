module "eks" {
  # checkov:skip=CKV_TF_1: ADD REASON
  source          = "terraform-aws-modules/eks/aws"
  version         = "v20.20.0"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.private_subnet_ids
  vpc_id          = var.vpc_id
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }
  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t3.medium"]

      min_size     = 2
      max_size     = 5
      desired_size = 2
    }
  }
}
