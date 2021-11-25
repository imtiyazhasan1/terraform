resource "helm_release" "cert_manager" {
  depends_on = [aws_route53_record.harbor-ns,aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.cert-manager-docker-secret]
  name       = "cert-manager"
  namespace  = "cert-manager"
  # create_namespace = true
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  version             = "v1.4.0"
  chart      = "cert-manager"
  set {
    name  = "installCRDs"
    value = "true"
  }
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.cert-manager-docker-secret.metadata.0.name
  }
}

resource "helm_release" "k8s_dashboard" {
  name       = "kubernetes-dashboard"
  namespace  = "kubernetes-dashboard"
  # create_namespace = true
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  chart      = "kubernetes-dashboard"
  version    = "4.2.0"
  depends_on = [aws_route53_record.harbor-ns,helm_release.nginx_ingress,kubernetes_secret.kubernetes-dashboard-docker-secret,helm_release.cert_manager]
  set {
    name  = "ingress.enabled"
    value = "true"
  }
  set {
    name  = "ingress.hosts[0]"
    value = "dashboard.${var.cluster_name}.gks.vodafone.com"
  }
  set {
    name  = "ingress.tls[0].secretName"
    value = "dashboard-tls"
  }
  set {
    name = "ingress.annotations\\.nginx\\.ingress\\.kubernetes\\.io/backend-protocol"
    value = "HTTPS"
  }
  set {
    name   = "ingress.annotations\\.kubernetes\\.io/ingress\\.class"
    value  = "nginx"
  }
  set {
    name  = "ingress.annotations\\.nginx\\.ingress\\.kubernetes\\.io/whitelist-source-range"
    value = "0.0.0.0/0"
  }
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.kubernetes-dashboard-docker-secret.metadata.0.name
  }
}

resource "helm_release" "aws_cloudwatch_metric" {
  depends_on = [aws_route53_record.harbor-ns,aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.aws-cloudwatch-docker-secret]
  name       = "aws-cloudwatch-metric"
  namespace  = "aws-cloudwatch"
  # create_namespace = true
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  chart      = "aws-cloudwatch-metrics"
  version    = "0.0.5"
  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.aws-cloudwatch-docker-secret.metadata.0.name
  }
}

resource "helm_release" "aws_calico" {
  depends_on = [
    aws_route53_record.harbor-ns,
    aws_eks_node_group.eks-cluster-workerNodeGroup,
    kubernetes_secret.kube-system-docker-secret
    ]
  name       = "aws-calico"
  namespace  = "kube-system"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  chart      = "aws-calico"
  version    = "0.3.5"
  timeout = 600
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.kube-system-docker-secret.metadata.0.name
  }
}

resource "helm_release" "metrics_server" {
  depends_on = [aws_route53_record.harbor-ns,aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kube-system-docker-secret]
  name       = "metrics-server"
  namespace  = "kube-system"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  chart      = "metrics-server"
  version    = "2.11.2"
  timeout = 600
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.kube-system-docker-secret.metadata.0.name
  }
}

resource "helm_release" "argocd" {
  count      = var.configure_gitops ? 1 : 0
  depends_on = [aws_route53_record.harbor-ns,helm_release.nginx_ingress,kubernetes_secret.argocd-docker-secret,helm_release.cert_manager]
  name       = "argocd"
  namespace  = "argocd"
  # create_namespace = true
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  chart      = "argo-cd"
  version    = "3.6.5"
  timeout = 700
  values = [
    file("charts/argocd/values.yaml"),
  ]
  set {
    name  = "server.ingress.enabled"
    value = "true"
  }
  set {
    name  = "server.ingress.ingressClassName"
    value = "nginx"
  }
  set {
    name  = "server.ingress.tls[0].secretName"
    value = "argotls"
  }
  set {
    name  = "server.ingress.https"
    value = "true"
  }
  set {
    name  = "server.ingress.hosts[0]"
    value = "argocd.${var.cluster_name}.gks.vodafone.com"
  }
  set {
    name  = "server.extraArgs[0]"
    value = "--insecure"
  }
  set {
    name  = "configs.secret.extra.dex\\.github\\.clientSecret"
    value = var.clientSecret
  }
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.argocd-docker-secret.metadata.0.name
  }
}

resource "helm_release" "kubewatch" {
  count      = var.configure_kubewatch ? 1 : 0
  depends_on = [aws_route53_record.harbor-ns,aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kube-system-docker-secret]
  name       = "kubewatch"
  namespace  = "kube-system"
  # create_namespace = true
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  version         = "3.2.6"
  chart      = "kubewatch"
  set {
    name  = "slack.enabled"
    value = "false"
  }
  set {
    name  = "msteams.enabled"
    value = "true"
  }
  set {
    name  = "msteams.webhookurl"
    value = var.msTeamsWebhook
  }
  set {
    name  = "namespaceToWatch"
    value = var.namespaceToWatch
  }
  set {
    name  = "rbac.create"
    value = "true"
  }
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.kube-system-docker-secret.metadata.0.name
  }
}