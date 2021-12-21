#data "aws_eks_cluster_auth" "eks" {
#  name  = aws_eks_cluster.eks-cluster.id
#}

terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.6.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "~> 2.4.1"
    }
  }
}

provider "kubernetes" {
   host                   = aws_eks_cluster.eks-cluster.endpoint
   cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
   token                  = data.aws_eks_cluster_auth.eks.token
   #load_config_file       = "false"
   exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
   }
}

provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks-cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eks.token
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}
