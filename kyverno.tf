resource "helm_release" "k8sPolicyCRDs" {
  name       = "kyverno-crds"
  namespace  = "kyverno"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = "SharmaA88"
  repository_password = "Thinkpad@2021"
  depends_on = [
    aws_eks_node_group.eks-cluster-workerNodeGroup,
	  aws_route53_record.harbor-ns,kubernetes_secret.kyverno-docker-secret
  ]
  chart      = "kyverno-crds"
  timeout = 300
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.kyverno-docker-secret.metadata.0.name
 }
}
resource "helm_release" "kyverno" {
  depends_on       = [aws_route53_record.harbor-ns,aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kyverno-docker-secret,helm_release.k8sPolicyCRDs]
  name       = "kyverno"
  namespace  = "kyverno"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = "SharmaA88"
  repository_password = "Thinkpad@2021"
  chart      = "kyverno"
  timeout = 300
  set {
    name  = "global.imagePullSecrets[0].name"
    value = kubernetes_secret.kyverno-docker-secret.metadata.0.name
  }
}
