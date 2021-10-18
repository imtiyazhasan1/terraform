# Random Number
resource "random_id" "random_number1" { 
    byte_length = 4
}
# Master IAM role
resource "aws_iam_role" "eks-cluster-role" {
  name = "terraform-eks-Master-role-${random_id.random_number1.hex}"

  assume_role_policy = <<-POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-cluster-role.name
}

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks-cluster-role.name
}
#*******----- end resource -----********


#IAM role and policy for worker node EC2 instances
resource "aws_iam_role" "eks-worker-node" {
  name = "terraform-eks-nodeGroup-role-${random_id.random_number1.hex}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

//inline policy for LogGroup
resource "aws_iam_role_policy" "terrafrom_log_policy" {
  name = "eks_log_policy"
  role = aws_iam_role.eks-worker-node.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:PutLogEvents"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
  }
  EOF
}

//inline policy for ASG
resource "aws_iam_role_policy" "terrafrom_ASG_policy" {
  name = "eks_ASG_policy"
  role = aws_iam_role.eks-worker-node.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
  }
  EOF
}

resource "aws_iam_policy" "eks_s3_ssm_policy" {
  name        = "eks_s3_ssm_policy-${random_id.random_number1.hex}"
  description = "eks_s3_ssm_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": "s3:GetObject",
        "Resource": [
            "arn:aws:s3:::aws-ssm-${var.region}/*",
            "arn:aws:s3:::aws-windows-downloads-${var.region}/*",
            "arn:aws:s3:::amazon-ssm-${var.region}/*",
            "arn:aws:s3:::amazon-ssm-packages-${var.region}/*",
            "arn:aws:s3:::${var.region}-birdwatcher-prod/*",
            "arn:aws:s3:::aws-ssm-distributor-file-${var.region}/*",
            "arn:aws:s3:::patch-baseline-snapshot-${var.region}/*"
        ]
    }
  ]
}
EOF
}

###########
# IAM Role for flow logs
###########
resource "aws_iam_role" "vpc_flow_log_cloudwatch" {
  name_prefix        = "enable-vpc-flow-log-role-"
  assume_role_policy = data.aws_iam_policy_document.flow_log_cloudwatch_assume_role.json
}

data "aws_iam_policy_document" "flow_log_cloudwatch_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    effect = "Allow"

    actions = ["sts:AssumeRole"]
  }
}

###########
# IAM Policy for flow logs
###########
resource "aws_iam_policy" "vpc_flow_log_cloudwatch" {
  name_prefix = "vpc-flow-log-cloudwatch-"
  policy      = data.aws_iam_policy_document.vpc_flow_log_cloudwatch.json
}

data "aws_iam_policy_document" "vpc_flow_log_cloudwatch" {
  statement {
    sid = "AWSVPCFlowLogsPushToCloudWatch"

    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy_attachment" "vpc_flow_log_cloudwatch" {
  role       = aws_iam_role.vpc_flow_log_cloudwatch.name
  policy_arn = aws_iam_policy.vpc_flow_log_cloudwatch.arn
}

resource "aws_iam_role_policy_attachment" "eks_s3_ssm_attach" {
  #  name       = "eks_s3_ssm_attach"
  policy_arn = aws_iam_policy.eks_s3_ssm_policy.arn
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_role_policy_attachment" "eks-CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonEC2RoleforSSM" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonS3ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_role_policy_attachment" "eks-AmazonElasticFileSystemFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemFullAccess"
  role       = aws_iam_role.eks-worker-node.name
}

resource "aws_iam_instance_profile" "worker-node" {
  name = "worker-node-${random_id.random_number1.hex}"
  role = aws_iam_role.eks-worker-node.name
}


