# Random Number
resource "random_id" "random_number_master_sg" { 
    byte_length = 4
}

#Default Security Group for master  
resource "aws_security_group" "eksDefaultMasterSG" {

  name        = "${var.vpc_name}-eksDefaultMasterSecurityGroup-${random_id.random_number_master_sg.hex}"
  description = "Default Security Group for master to commuincate with worker node"
  vpc_id      = aws_vpc.eksVPC.id

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-eksDefaultMasterSG"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_security_group_rule" "master-ingress-all" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.eksDefaultMasterSG.id
  type                     = "ingress"
  security_group_id        = aws_security_group.eksDefaultMasterSG.id
}


resource "aws_security_group_rule" "master-ingress-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eksWorkerNodeGroup.id
  type                     = "ingress"
  security_group_id        = aws_security_group.eksDefaultMasterSG.id
}



resource "aws_security_group_rule" "master-egress-custom-tcp" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eksWorkerNodeGroup.id
  type                     = "egress"
  security_group_id        = aws_security_group.eksDefaultMasterSG.id
}

#*******----- end resource -----********


