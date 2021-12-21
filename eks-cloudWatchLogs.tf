# Random Number
resource "random_id" "random_number2" { 
    byte_length = 4
}

resource "aws_cloudwatch_log_group" "eks-cluster-logs" {
  name = "eks-clusterlogs-${random_id.random_number2.hex}"

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}"
      Managed-by = "Terraform"
    }
  )
}

##aws cloudwatch logs
resource "helm_release" "aws-for-fluentbit" {
   depends_on = [aws_eks_node_group.eks-cluster-workerNodeGroup,kubernetes_secret.kube-system-docker-secret,aws_efs_file_system.eksStorage,aws_efs_mount_target.eksStorageTarget]
   name       = "aws-for-fluentbit"
   repository = "https://registry.eu-central-1.harbor.vodafone.com/chartrepo/gks-public-cloud"
   repository_username = lookup(var.Harbor_creds,"username")
   repository_password = lookup(var.Harbor_creds,"password")
   chart      = "aws-for-fluent-bit"
   version    = "0.1.11"
   namespace  = "kube-system"

   set {
     name  = "cloudWatch.region"
     value = var.region
   }
   set {
     name  = "image.tag"
     value = "2.19.1"
   }
   set {
     name  = "image.repository"
     value = "registry.eu-central-1.harbor.vodafone.com/gks-public-cloud/aws-for-fluent-bit"
   }
   set {
    name  = "imagePullSecrets[0].name"
    value = kubernetes_secret.kube-system-docker-secret.metadata.0.name
  }
   set {
     name  = "firehose.enabled"
     value = "false"
   }
   set {
     name  = "kinesis.enabled"
     value = "false"
   }
   set {
    name  = "elasticsearch.enabled"
    value = "false"
  }
   set {
    name  = "cloudWatch.logGroupName"
    value = "/aws/eks/fluentbit-cloudwatch/${var.cluster_name}/logs"
  }
}
