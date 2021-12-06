# Endpoint for S3 (Gateway)
resource "aws_vpc_endpoint" "S3" {

  vpc_id            = aws_vpc.eksVPC.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-s3"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_route_table_association" "S3_attach" {

  count           = var.count_subnet
  route_table_id  = aws_route_table.eksVpcRouteTable[0].id
  vpc_endpoint_id = aws_vpc_endpoint.S3.id
}
#*******----- end resource -----********

# Endpoint for EC2 (Interface)
resource "aws_vpc_endpoint" "ec2" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.ec2"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-ec2"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "ec2_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.ec2.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for EC2-Messages (Interface)
resource "aws_vpc_endpoint" "ec2messages" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-ec2messages"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "ec2messages_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.ec2messages.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for Autoscaling (Interface)
resource "aws_vpc_endpoint" "autoscaling" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.autoscaling"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-autoscaling"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "autoscaling_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.autoscaling.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for SSM (Interface)
resource "aws_vpc_endpoint" "ssm" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-ssm"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "ssm_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.ssm.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for SSM-Messages (Interface)
resource "aws_vpc_endpoint" "ssm_messages" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-ssm_messages"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "ssm_messages_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.ssm_messages.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for ECR API (Interface)
resource "aws_vpc_endpoint" "ecrAPI" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-ecr_api"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "ecrAPI_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.ecrAPI.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for ECR DKR (Interface)
resource "aws_vpc_endpoint" "ecrDkr" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-ecr_dkr"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "ecrDkr_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.ecrDkr.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for logs (Interface)
resource "aws_vpc_endpoint" "logs" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-logs"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "logs_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.logs.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for sts (Interface)
resource "aws_vpc_endpoint" "sts" {

  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.${var.region}.sts"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  private_dns_enabled = true

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-endpoint-sts"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_vpc_endpoint_subnet_association" "sts_attach" {
  count           = var.count_subnet
  vpc_endpoint_id = aws_vpc_endpoint.sts.id
  subnet_id       = aws_subnet.eksVpcSubnet[count.index].id
}
#*******----- end resource -----********

# Endpoint for Harbor (Interface)
resource "aws_vpc_endpoint" "harbor" {
  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.vpce.${var.region}.${var.harbor_endpoints[var.region]}"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpointSG.id]
  subnet_ids          = aws_subnet.eksVpcSubnet.*.id

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-harbor-endpoint"
      Managed-by = "Terraform"
    }
  )
}

################ Private Zone  for Harbor (Interface) ####################

resource "aws_route53_zone" "private" {
  name = "internal.harbor.vodafone.com"
  comment = "${var.cluster_name}-harbor-endpoint-host-zone"

  vpc {
    vpc_id = aws_vpc.eksVPC.id
  }
  
  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-route53-zone"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_route53_record" "harbor-ns" {
  depends_on = [aws_vpc_endpoint.harbor]
  zone_id = aws_route53_zone.private.zone_id
  name    = "${var.harbor_Dns_targets[var.region]}"
  type    = "A"
  alias {
    name                   = "${element(aws_vpc_endpoint.harbor.dns_entry, 0)["dns_name"]}"
    zone_id                = "${element(aws_vpc_endpoint.harbor.dns_entry, 0)["hosted_zone_id"]}"
    evaluate_target_health = true
  }
}

# Endpoint for TrendMicro (Interface)
resource "aws_vpc_endpoint" "trendmicro" {
  vpc_id              = aws_vpc.eksVPC.id
  service_name        = "com.amazonaws.vpce.${var.region}.${var.trendmicro_endpoints[var.region]}"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.trendMicroEndpointSG.id]
  subnet_ids          = aws_subnet.eksVpcSubnet.*.id

  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-trendmicro-endpoint"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_route53_zone" "trendmicro-private-zone" {
  name = "aws-shared.vodafone.com"
  comment = "${var.cluster_name}-trendmicro-endpoint-host-zone"

  vpc {
    vpc_id = aws_vpc.eksVPC.id
  }
  
  tags = merge(local.common_tags,
    {
      Name       = "${var.vpc_name}-trendmicro-route53-zone"
      Managed-by = "Terraform"
    }
  )
}

resource "aws_route53_record" "trendmicro-dsm-ns" {
  depends_on = [aws_vpc_endpoint.trendmicro]
  zone_id = aws_route53_zone.trendmicro-private-zone.zone_id
  name    = "${var.trendmicro_dns_targets_dsm[var.region]}"
  type    = "A"
  alias {
    name                   = "${element(aws_vpc_endpoint.trendmicro.dns_entry, 0)["dns_name"]}"
    zone_id                = "${element(aws_vpc_endpoint.trendmicro.dns_entry, 0)["hosted_zone_id"]}"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "trendmicro-sps-ns" {
  depends_on = [aws_vpc_endpoint.trendmicro]
  zone_id = aws_route53_zone.trendmicro-private-zone.zone_id
  name    = "${var.trendmicro_dns_targets_sps[var.region]}"
  type    = "A"
  alias {
    name                   = "${element(aws_vpc_endpoint.trendmicro.dns_entry, 0)["dns_name"]}"
    zone_id                = "${element(aws_vpc_endpoint.trendmicro.dns_entry, 0)["hosted_zone_id"]}"
    evaluate_target_health = true
  }
}
