resource "helm_release" "eksALB" {
  name       = "eks-alb"
  namespace  = "kube-system"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  chart      = "aws-load-balancer-controller"
  version    = "1.2.7"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  depends_on = [aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kube-system-docker-secret]
  set {
    name  = "image.repository"
    value = "registry.eu-central-1.harbor.vodafone.com/vf-gks-devsecops/amazon/aws-alb-ingress-controller"
  }
  set {
    name  = "image.tag"
    value = "v2.2.4"
  }
  set {
    name  = "imagePullSecrets[0].name"
    value = kubernetes_secret.kube-system-docker-secret.metadata.0.name
  }
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "ingressClass"
    value = "alb"
  }
  set {
    name  = "region"
    value = var.region
  }
  set {
    name  = "vpcId"
    value = aws_vpc.eksVPC.id
  }

  set {
    name  = "enableShield"
    value = "true"
  }
  set {
    name  = "enableWaf"
    value = "false"
  }
  set {
    name  = "enableWafv2"
    value = "true"
  }
}