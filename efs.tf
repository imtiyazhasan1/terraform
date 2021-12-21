## This part of efs creation would be applied for only new vpc. For existing vpc this part can be removed
## starts efs creation
# Random Number
resource "random_id" "random_number3" { 
    byte_length = 4
}

resource "aws_efs_file_system" "eksStorage" {
  creation_token = "kubernetes-storage-${random_id.random_number3.hex}"

  tags = merge(local.common_tags,
    {
      Name       = "${var.cluster_name}-EFS-storage"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_efs_mount_target" "eksStorageTarget" {

  count           = var.count_subnet
  file_system_id  = aws_efs_file_system.eksStorage.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
  security_groups = [aws_security_group.eksWorkerNodeGroup.id]
}

## ends efs creation

## Starts efs controller deployment within eks
## This is must have section for all type of clsuter deployment.

resource "helm_release" "helmefs" {
  count      = var.configure_efs ? 1 : 0
  name       = "efs"
  namespace  = "kube-system"
  repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
  chart      = "aws-efs-csi-driver"
  version    = "2.1.5"
  repository_username = lookup(var.Harbor_creds,"username")
  repository_password = lookup(var.Harbor_creds,"password")
  depends_on = [aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kube-system-docker-secret,aws_efs_file_system.eksStorage,aws_efs_mount_target.eksStorageTarget]
  set {
    name  = "imagePullSecrets.name"
    value = kubernetes_secret.kube-system-docker-secret.metadata.0.name
  }
  set {
    name  = "image.repository"
    value = "registry.eu-central-1.harbor.vodafone.com/gks-public-cloud/aws-efs-csi-driver"
  }
  set {
    name  = "image.tag"
    value = "v1.3.3"
  }
}

resource "kubernetes_storage_class" "efssc" {
  count      = var.configure_efs ? 1 : 0
  metadata {
    name = "efs-sc-${random_id.random_number3.hex}"
  }
    depends_on = [aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kube-system-docker-secret,aws_efs_file_system.eksStorage,aws_efs_mount_target.eksStorageTarget]
  storage_provisioner = "efs.csi.aws.com"
  reclaim_policy      = "Delete"
  volume_binding_mode = "Immediate"
  parameters = {
    provisioningMode = "efs-ap"
    basePath         = "/data"
    directoryPerms   = "700"
    fileSystemId     = aws_efs_file_system.eksStorage.id
    gidRangeEnd      = "2000"
    gidRangeStart    = "1000"
  }
  mount_options = [ "tls" ]
}
## end efs controller deployment
