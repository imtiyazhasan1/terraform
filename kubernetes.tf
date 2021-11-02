# data "aws_caller_identity" "current" {}

locals {

  certificate_authority_data               = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data) 

  # Add worker nodes role ARNs (could be from many un-managed worker groups) to the ConfigMap
  # Note that we don't need to do this for managed Node Groups since EKS adds their roles to the ConfigMap automatically
  map_worker_roles = [
    {
      rolearn : "${aws_iam_role.eks-worker-node.arn}"
      username : "system:node:{{EC2PrivateDNSName}}"
      groups : [
        "system:bootstrappers",
        "system:nodes"
      ]
    },
    {
      rolearn: "arn:aws:iam::${var.tenantAccountId}:role/gks-DevOps"
      username: "gks-DevOps"
      groups : [
        "system:masters"
      ]
    },
    {
      rolearn: "arn:aws:iam::${var.tenantAccountId}:role/gks_devops"
      username: "gks_devops"
      groups : [
        "system:masters"
      ]
    },
    {
      rolearn: "arn:aws:iam::${var.sourceAccountId}:role/gocd-agent-deploy-role"
      username: "gocd-agent-deploy-role"
      groups : [
        "system:masters"
      ]
    }
  ]
}

data "aws_eks_cluster" "eks" {
  name  = aws_eks_cluster.eks-cluster.id
}

data "aws_eks_cluster_auth" "eks" {
  name  = aws_eks_cluster.eks-cluster.id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
  load_config_file       = "false"
  version                = "~> 1.10"
}

resource "kubernetes_config_map" "aws_auth" {
  depends_on = [aws_eks_cluster.eks-cluster]
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles    = yamlencode(distinct(concat(local.map_worker_roles, var.additional_iam_roles, var.cluster_admin_access)))
  }
}
