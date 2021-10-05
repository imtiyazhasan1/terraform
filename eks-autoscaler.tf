resource "random_id" "random_number_role" { 
    byte_length = 4
}

resource "aws_iam_policy" "cluster_autoscaler_policy" {
  name_prefix = "cluster-autoscaler-"
  description = "EKS cluster-autoscaler policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    sid       = "clusterAutoscaler"
    effect    = "Allow"
    actions   = [
        "autoscaling:UpdateAutoScalingGroup",
        "autoscaling:DescribeAutoScalingGroups",
        "autoscaling:DescribeAutoScalingInstances",
        "autoscaling:DescribeLaunchConfigurations",
        "autoscaling:DescribeTags",
        "autoscaling:SetDesiredCapacity",
        "autoscaling:TerminateInstanceInAutoScalingGroup",
        "ec2:DescribeLaunchTemplateVersions"
    ]
    resources = ["*"]
  }
}

data "tls_certificate" "cluster" {
  depends_on   = [aws_eks_cluster.eks-cluster]
  url = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "cluster" {
  depends_on   = [aws_eks_cluster.eks-cluster]
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks-cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "cluster_autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.cluster.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:aws-node"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.cluster.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cluster_autoscaler_role" {
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role_policy.json
  managed_policy_arns = [aws_iam_policy.cluster_autoscaler_policy.arn]
  name               = "cluster-autoscaler-role-${random_id.random_number_role.hex}"
}

resource "helm_release" "cluster_autoscaler" {
  depends_on   = [aws_eks_cluster.eks-cluster]
  name        = "cluster-autoscaler"
  namespace   = "kube-system"
  repository  = "https://kubernetes.github.io/autoscaler"
  chart       = "cluster-autoscaler"

  set{
    name  = "cloudProvder"
    value = "aws"
  }

  set{
    name  = "awsRegion"
    value = var.region
  }

  set{
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set{
    name  = "rbac.create"
    value = true
  }

  set{
    name  = "rbac.serviceAccountAnnotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler_role.arn
  }
}