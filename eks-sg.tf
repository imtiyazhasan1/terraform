# Random Number
resource "random_id" "random_number_sg" { 
    byte_length = 4
}

#Security Group for all the endpoints (attach to interface)
resource "aws_security_group" "endpointSG" {

  name        = "${var.vpc_name}-endpointSecurityGroup-${random_id.random_number_sg.hex}"
  description = "To govern who can access the endpoint - worker node"
  vpc_id      = aws_vpc.eksVPC.id

  ingress {
    description     = "TLS from worker node"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.endpointClientSG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpointInterfaceSG"
      Managed-by = "Terraform"
    }
  )
}
#*******----- end resource -----********

#Security Group for endpoints Client i.e  launch configuration (worker node)
resource "aws_security_group" "endpointClientSG" {

  name        = "${var.vpc_name}-endpointClientSecurityGroup-${random_id.random_number_sg.hex}"
  description = "Resource access to VPC endpoint"
  vpc_id      = aws_vpc.eksVPC.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpointClientInterfaceSG"
      Managed-by = "Terraform"
    }
  )
}
#*******----- end resource -----********

