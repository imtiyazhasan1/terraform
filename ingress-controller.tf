resource "helm_release" "nginx_ingress" {
  depends_on       = [aws_route53_record.harbor-ns,aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.ingress-nginx-docker-secret]
  name             = "nginx-ingress"
  namespace        = "ingress-nginx"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  version             = "4.0.5"
  chart            = "ingress-nginx"
  values           = [
    file("charts/ingress-nginx/values.yaml"),
  ]
  timeout = 900
}