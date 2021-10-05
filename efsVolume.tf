# Random Number
resource "random_id" "random_number3" { 
    byte_length = 4
}

resource "aws_efs_file_system" "eksStorage" {
  creation_token = "kubernetes-storage-${random_id.random_number3.hex}"

  tags = merge(local.common_tags,
    {
      Name       = "${var.cluster_name}-EFS-storage-for-kubernetes"
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