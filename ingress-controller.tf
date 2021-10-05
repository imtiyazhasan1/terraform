provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.eks-cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.eks-cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

resource "helm_release" "nginx_ingress" {
  depends_on       = [aws_route53_record.harbor-ns,aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.ingress-nginx-docker-secret]
  name             = "nginx-ingress"
  namespace        = "ingress-nginx"
  # create_namespace = "true"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = "SharmaA88"
  repository_password = "Thinkpad@2021"
  chart            = "ingress-nginx"
  values           = [
    file("charts/ingress-nginx/values.yaml"),
  ]
  timeout = 900
}