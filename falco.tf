resource "helm_release" "falco" {
  depends_on       = [aws_route53_record.harbor-ns,helm_release.nginx_ingress,kubernetes_secret.falco-docker-secret]
  name       = "falco"
  namespace  = "falco"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  chart      = "falco"
  timeout = 300
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.falco-docker-secret.metadata.0.name
  }
}
