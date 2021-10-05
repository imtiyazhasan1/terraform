resource "helm_release" "falco" {
  depends_on       = [aws_route53_record.harbor-ns,helm_release.nginx_ingress,kubernetes_secret.falco-docker-secret]
  name       = "falco"
  namespace  = "falco"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = "SharmaA88"
  repository_password = "Thinkpad@2021"
  chart      = "falco"
  timeout = 300
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.falco-docker-secret.metadata.0.name
  }
}

resource "helm_release" "falcosidekick" {
  depends_on       = [aws_route53_record.harbor-ns,aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.falco-docker-secret]
  name       = "falcosidekick"
  namespace  = "falco"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = "SharmaA88"
  repository_password = "Thinkpad@2021"
  chart      = "falcosidekick"
  timeout = 300
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.falco-docker-secret.metadata.0.name
  }
  set {
    name  = "falcosidekick.enabled"
    value = "true"
  }
  set {
    name  = "falcosidekick.webui.enabled"
    value = "true"
  }
}
