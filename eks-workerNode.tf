# Random Number
resource "random_id" "random_number_ng" { 
    byte_length = 4
}

data "template_file" "userdata" {
  template = file("${path.module}/eks-userdata.tpl")
  vars = {
    ClusterName        = var.cluster_name
    region             = var.region
    ClusterAPIEndpoint = aws_eks_cluster.eks-cluster.endpoint
    ClusterCA          = aws_eks_cluster.eks-cluster.certificate_authority[0].data
    NodeInstanceRole   = aws_iam_role.eks-worker-node.arn
  }
}

# resource "aws_launch_configuration" "worker-node-config2" {
#   associate_public_ip_address = false
#   iam_instance_profile        = aws_iam_instance_profile.worker-node.name
#   image_id                    = var.ami
#   instance_type               = var.instance_type
#   name_prefix                 = var.cluster_name
#   security_groups             = [aws_security_group.eksWorkerNodeGroup.id, aws_security_group.endpointClientSG.id]
#   //user_data_base64          = base64encode(local.demo-node-userdata)
#   user_data = data.template_file.userdata.rendered

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_launch_configuration" "worker-node-config_new" {
#   associate_public_ip_address = true
#   iam_instance_profile        = aws_iam_instance_profile.worker-node.name
#   image_id                    = var.ami
#   instance_type               = var.instance_type
#   name_prefix                 = "lt-"
#   security_groups             = [aws_security_group.eksWorkerNodeGroup.id, aws_security_group.endpointClientSG.id]
#   //user_data_base64          = base64encode(local.demo-node-userdata)
#   user_data = data.template_file.userdata.rendered

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_launch_template" "worker-node-config_template" {


  name_prefix   = var.cluster_name
  image_id      = var.ami
  instance_type = var.instance_type

  user_data = base64encode(data.template_file.userdata.rendered)
  vpc_security_group_ids = [
    aws_security_group.eksWorkerNodeGroup.id, aws_security_group.endpointClientSG.id
  ]

  # instance_initiated_shutdown_behavior = "terminate"

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.common_tags,
      {
        Managed-by = "Terraform"
        Name       = "${var.cluster_name}"
      }
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(local.common_tags,
      {
        Managed-by = "Terraform"
        Name       = "${var.cluster_name}"
      }
    )
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.common_tags,
    {
      Managed-by = "Terraform"
    }
  )
}

resource "aws_eks_node_group" "eks-cluster-workerNodeGroup" {
    cluster_name    = aws_eks_cluster.eks-cluster.name
    node_group_name = "${var.cluster_name}-workerNodeGroup-${random_id.random_number_ng.hex}"
    node_role_arn   = aws_iam_role.eks-worker-node.arn
    subnet_ids      = aws_subnet.eksVpcSubnet.*.id
    scaling_config {
        desired_size = var.desired_capacity
        max_size     = var.max_size
        min_size     = var.min_size
    }

    launch_template {
        name      = aws_launch_template.worker-node-config_template.name
        version   = "$Latest"
    }

    tags = merge(local.common_tags,
        {
          "Name"                                             = "${var.vpc_name}"
          "kubernetes.io/cluster/${var.cluster_name}"        = "shared"
          "k8s.io/cluster-autoscaler/${var.cluster_name}"    = "owned"
          "k8s.io/cluster-autoscaler/enabled"                = true
        }
    )

    depends_on = [
        aws_launch_template.worker-node-config_template,
        aws_iam_role_policy_attachment.eks_s3_ssm_attach,
        aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
        aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
        aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
        aws_iam_role_policy_attachment.eks-CloudWatchAgentServerPolicy,
        aws_iam_role_policy_attachment.eks-AmazonEC2RoleforSSM,
        aws_iam_role_policy_attachment.eks-AmazonS3ReadOnlyAccess,
        aws_iam_role_policy_attachment.eks-AmazonSSMManagedInstanceCore,
        kubernetes_config_map.aws_auth
    ]

    lifecycle {
        create_before_destroy = true
    }
}
