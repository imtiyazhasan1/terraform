# Random Number
resource "random_id" "random_number_worker_sg" { 
    byte_length = 4
}
#Default Security Group for master  
resource "aws_security_group" "eksWorkerNodeGroup" {

  name        = "${var.vpc_name}-eksWorkerNodeSecurityGroup-${random_id.random_number_worker_sg.hex}"
  description = "Default Security Group for all node commuincate"
  vpc_id      = aws_vpc.eksVPC.id

  tags = merge(local.common_tags,
    {
      Name                                        = "${var.vpc_name}-eksWorkerNodeGroupSG"
      Managed-by                                  = "Terraform"
      "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    }
  )
}

resource "aws_security_group_rule" "workerNode-ingress-all" {
  description              = "Node to Node "
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eksWorkerNodeGroup.id
  type                     = "ingress"
  security_group_id        = aws_security_group.eksWorkerNodeGroup.id
}

resource "aws_security_group_rule" "workerNode-egress-all" {
  description       = "Node to Node "
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
  security_group_id = aws_security_group.eksWorkerNodeGroup.id
}


resource "aws_security_group_rule" "workerNode-ingress-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eksDefaultMasterSG.id
  type                     = "ingress"
  security_group_id        = aws_security_group.eksWorkerNodeGroup.id
}



resource "aws_security_group_rule" "workerNode-ingress-custom-tcp" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eksDefaultMasterSG.id
  type                     = "ingress"
  security_group_id        = aws_security_group.eksWorkerNodeGroup.id
}
