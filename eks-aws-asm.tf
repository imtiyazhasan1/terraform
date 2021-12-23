resource "helm_release" "asm-csi-driver" {
  name       = "asm-csi-driver"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  namespace  = "kube-system"
  version    =  "1.0.0"
  depends_on = [aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kube-system-docker-secret,aws_efs_file_system.eksStorage,aws_efs_mount_target.eksStorageTarget]
  chart      = "secrets-store-csi-driver"
  set {
    name  = "syncSecret.enabled"
    value = "true"
  }
  set {
    name  = "linux.image.repository"
    value = "registry.eu-central-1.harbor.vodafone.com/gks-public-cloud/csi-secrets-store/driver"
  }
  set {
    name  = "linux.crds.image.repository"
    value = "registry.eu-central-1.harbor.vodafone.com/gks-public-cloud/csi-secrets-store/driver-crds"
  }
  set {
    name  = "linux.registrarImage.repository"
    value = "registry.eu-central-1.harbor.vodafone.com/gks-public-cloud/sig-storage/csi-node-driver-registrar"
  }
  set {
    name  = "linux.livenessProbeImage.repository"
    value = "registry.eu-central-1.harbor.vodafone.com/gks-public-cloud/sig-storage/livenessprobe"
  }
  set {
    name  = "imagePullSecrets[0].name"
    value = kubernetes_secret.kube-system-docker-secret.metadata.0.name
  }
}


resource "helm_release" "eks-secret-csi" {
  name       = "eks-secret-csi"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  namespace  = "kube-system"
  version    =  "2.0.1"
  depends_on = [aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kube-system-docker-secret]
  chart      = "eks-csi"
  set {
    name  = "image.repository"
    value = "registry.eu-central-1.harbor.vodafone.com/gks-public-cloud/aws-secrets-manager/secrets-store-csi-driver-provider-aws"
  }
  set {
    name  = "image.tag"
    value = "1.0.r2-2021.08.13.20.34-linux-amd64"
  }
  set {
    name  = "imagePullSecrets[0].name"
    value = kubernetes_secret.kube-system-docker-secret.metadata.0.name
  }
}
