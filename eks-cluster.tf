resource "aws_eks_cluster" "eks-cluster" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks-cluster-role.arn
  version                   = var.kubernetes_version
  enabled_cluster_log_types = var.enabled_cluster_log_types


  vpc_config {
    subnet_ids              = aws_subnet.eksVpcSubnet.*.id
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.whitelisted_ips
    security_group_ids      = [
      aws_security_group.eksDefaultMasterSG.id
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy,
    aws_cloudwatch_log_group.eks-cluster-logs
  ]


  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}"
      Managed-by = "Terraform"
      Role       = "Master"
    }
  )
  
  encryption_config {
    provider {
      key_arn = aws_kms_key.cluster_kms_key.arn
    }
    resources = ["secrets"]
  }
}

resource "aws_kms_key" "cluster_kms_key" {
  description             = "${var.cluster_name} KMS key"
  deletion_window_in_days = 7
  tags = merge(local.common_tags,
    {
      ClusterName       = "${var.cluster_name}"
      Managed-by = "Terraform"
    }
  )
}