################ ArgoCD Secrets ##############################
resource "kubernetes_namespace" "argocd-ns" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "argocd"
  }
}

resource "kubernetes_secret" "argocd-docker-secret" {
  depends_on = [kubernetes_namespace.argocd-ns]
  metadata {
    name = "regcred"
    namespace = "argocd"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://registry.eu-central-1.harbor.vodafone.com": {
      "auth": "${base64encode(local.docker_secret)}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

################ AWS Kubernetes Dashboard Secrets ##############################

resource "kubernetes_namespace" "kubernetes-dashboard-ns" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "kubernetes-dashboard"
  }
}

resource "kubernetes_secret" "kubernetes-dashboard-docker-secret" {
  depends_on = [kubernetes_namespace.kubernetes-dashboard-ns]
  metadata {
    name = "regcred"
    namespace = "kubernetes-dashboard"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://registry.eu-central-1.harbor.vodafone.com": {
      "auth": "${base64encode(local.docker_secret)}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

################ AWS CloudWatcth Secrets ##############################
resource "kubernetes_namespace" "aws-cloudwatch-ns" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "aws-cloudwatch"
  }
}

resource "kubernetes_secret" "aws-cloudwatch-docker-secret" {
  depends_on = [kubernetes_namespace.aws-cloudwatch-ns]
  metadata {
    name = "regcred"
    namespace = "aws-cloudwatch"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://registry.eu-central-1.harbor.vodafone.com": {
      "auth": "${base64encode(local.docker_secret)}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

################ AWS Cert Manager Secrets ##############################

resource "kubernetes_namespace" "cert-manager-ns" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "cert-manager"
  }
}

resource "kubernetes_secret" "cert-manager-docker-secret" {
  depends_on = [kubernetes_namespace.cert-manager-ns]
  metadata {
    name = "regcred"
    namespace = "cert-manager"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://registry.eu-central-1.harbor.vodafone.com": {
      "auth": "${base64encode(local.docker_secret)}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

################ AWS Callico Secrets ##############################

resource "kubernetes_secret" "kube-system-docker-secret" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name = "regcred"
    namespace = "kube-system"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://registry.eu-central-1.harbor.vodafone.com": {
      "auth": "${base64encode(local.docker_secret)}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

################ Ingress Controller Secrets ##############################

resource "kubernetes_namespace" "ingress-nginx-ns" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "ingress-nginx"
  }
}

resource "kubernetes_secret" "ingress-nginx-docker-secret" {
  depends_on = [kubernetes_namespace.ingress-nginx-ns]
  metadata {
    name = "regcred"
    namespace = "ingress-nginx"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://registry.eu-central-1.harbor.vodafone.com": {
      "auth": "${base64encode(local.docker_secret)}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

################ Kyverno ##############################
resource "kubernetes_namespace" "kyverno-ns" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "kyverno"
  }
}

resource "kubernetes_secret" "kyverno-docker-secret" {
  depends_on = [kubernetes_namespace.kyverno-ns]
  metadata {
    name = "regcred"
    namespace = "kyverno"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://registry.eu-central-1.harbor.vodafone.com": {
      "auth": "${base64encode(local.docker_secret)}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}

################ falco ##############################
resource "kubernetes_namespace" "falco-ns" {
  depends_on  = [kubernetes_config_map.aws_auth]
  metadata {
    name      = "falco"
  }
}

resource "kubernetes_secret" "falco-docker-secret" {
  depends_on = [kubernetes_namespace.falco-ns]
  metadata {
    name = "regcred"
    namespace = "falco"
  }

  data = {
    ".dockerconfigjson" = <<DOCKER
{
  "auths": {
    "https://registry.eu-central-1.harbor.vodafone.com": {
      "auth": "${base64encode(local.docker_secret)}"
    }
  }
}
DOCKER
  }
  type = "kubernetes.io/dockerconfigjson"
}