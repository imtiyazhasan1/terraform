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
