data "aws_eks_cluster_auth" "eks" {
  name  = aws_eks_cluster.eks-cluster.id
}

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
