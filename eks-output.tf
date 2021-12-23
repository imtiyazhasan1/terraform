output "cluster-name" {
  value = var.cluster_name
}

output "eks_endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "genrate_kubeconfig" {
  value = "aws eks update-kubeconfig --name ${var.cluster_name} --region ${var.region}"
}

output "dashboard_url" {
  value = "dashboard.${var.cluster_name}.gks.vodafone.com"
}

output "argocd_url" {
  value = "argocd.${var.cluster_name}.gks.vodafone.com"
}

output "cluster_ca_certificate" {
  value = element(aws_eks_cluster.eks-cluster.certificate_authority, 0)["data"]
}

output "storageDNS" {
  value = aws_efs_file_system.eksStorage.dns_name
}

output "cluster_default_sg" {
  value = element(aws_eks_cluster.eks-cluster.vpc_config, 0)["cluster_security_group_id"]
}

output "tags" {
  value = local.common_tags
}

output "vpc_id" {
  value = aws_vpc.eksVPC.id
}
output "docker_secret" {
  value = local.docker_secret
}