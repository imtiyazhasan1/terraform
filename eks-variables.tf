######################### varibale for meinDSL private vpc and eks cluster########################

variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "subnets_cidr_block" {
  type        = list(string)
  description = "Subnet CIDR block."
}

variable "vpc_id" {
  type        = string
  description = "ID of required VPC."
}

variable "NatGatewayId" {
  type        = string
  description = "ID of the NAT Gateway in the provided VPC."
}

variable "count_subnet" {
  type        = number
  description = "No of subnet required"
}

variable "availability_zones" {
  type        = list(string)
#  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  description = "No of subnet required"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "ami" {
  type        = string
#  default     = "ami-0fa35f245d939af85" // for eu-central-1
  description = "The Amazon EKS-optimized Linux AMI is built on top of Amazon Linux 2 https://docs.aws.amazon.com/eks/latest/userguide/eks-optimized-ami.html"
}

variable "eks_cidr_block" {
  type        = string
  description = "CIDR block for EKS VPC"
}

variable "cluster_name" {
  type        = string
#  default     = "gks-eks-cluster"
  description = "EKS cluster name"
}

variable "instance_type" {
  type        = string
#  default     = "t2.large"
  description = "instance type for worker node"
}

variable "kubernetes_version" {
  type        = string
#  default     = "1.16"
  description = "Desired Kubernetes master version."
}

variable "endpoint_private_access" {
  type        = bool
#  default     = true
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled."
}

variable "endpoint_public_access" {
  type        = bool
#  default     = true
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled. "
}

variable "enabled_cluster_log_types" {
  type        = list(string)
#  default     = []
  description = "Logging for kubernetes"
}

variable "desired_capacity" {
  type        = number
  description = "desired no of instance for cluster"
}

variable "max_size" {
  type        = number
  description = "max no of instance for cluster"
}

variable "min_size" {
  type        = number
  description = "min no of instance for cluster"
}

variable "high_cpu_util" {
  type        = number
  description = "max no of instance for cluster"
  default     = "80"
}

variable "low_cpu_util" {
  type        = number
  description = "min no of instance for cluster"
  default     = "40"
}

variable "githubOrganizationName" {
  type        = string
}

variable "teamName" {
  type        = string
}

variable "clientId" {
  type        = string
}

variable "clientSecret" {
  type        = string
}

variable "tenantAccountId" {
  type        = string
}

variable "msTeamsWebhook" {
  type        = string
}

variable "namespaceToWatch" {
  type        = string
}

variable "harbor_endpoints" {
  type = map(string)
  default = {
    "eu-west-1"    = "vpce-svc-0f8e9dff8e7b67d82"
    "eu-west-2"    = "vpce-svc-0cb43646946dxxxxx"
    "eu-central-1" = "vpce-svc-0cb43646946d272d3"
  }
}

variable "harbor_Dns_targets" {
  type = map(string)
  default = {
    "eu-west-1"    = "registry.internal.harbor.vodafone.com"
    "eu-west-2"    = "registry.internal.harbor.vodafone.com"
    "eu-central-1" = "registry.internal.harbor.vodafone.com"
  }
}

variable "trendmicro_endpoints" {
  type = map(string)
  default = {
    "eu-west-1"    = "vpce-svc-021ea81a4876d04a1"
    "eu-west-2"    = "vpce-svc-0370ca0f96da7ae00"
    "eu-central-1" = "vpce-svc-04995ddbf25c34631"
    "eu-south-1"   = "vpce-svc-04be9df225a5989fd"
  }
}

variable "trendmicro_dns_targets_dsm" {
  type = map(string)
  default = {
    "eu-west-1"    = "trend-dsm.aws-shared.vodafone.com"
    "eu-west-2"    = "trend-dsm.aws-shared.vodafone.com"
    "eu-central-1" = "trend-dsm.aws-shared.vodafone.com"
  }
}

variable "trendmicro_dns_targets_sps" {
  type = map(string)
  default = {
    "eu-west-1"    = "trend-sps.aws-shared.vodafone.com"
    "eu-west-2"    = "trend-sps.aws-shared.vodafone.com"
    "eu-central-1" = "trend-sps.aws-shared.vodafone.com"
  }
}
######################### varibale for Tagging Management System########################

variable "Project" {
  type        = string
  description = "Project Name"
}

variable "ManagedBy" {
  type        = string
  description = "ManagedBy"
}

variable "TaggingVersion" {
  type        = string
  description = "TaggingVersion"
}

variable "Confidentiality" {
  type        = string
  description = "Confidentiality"
}

variable "Environment" {
  type        = string
  description = "Environment"
}

variable "SecurityZone" {
  type        = string
  description = "SecurityZone"
}

######################### varibale for AWS Auth and Namespaces########################

# variable "wait_for_cluster_command" {
#   type        = string
#   default     = "curl --silent --fail --retry 30 --retry-delay 3 --retry-connrefused --insecure --output /dev/null $ENDPOINT/healthz"
#   description = "`local-exec` command to execute to determine if the EKS cluster is healthy. Cluster endpoint are available as environment variable `ENDPOINT`"
# }
# variable "local_exec_interpreter" {
#   type        = list(string)
#   default     = ["/bin/sh", "-c"]
#   description = "shell to use for local_exec"
# }

variable "namespaces"{
  type = list(object({
    namespace_name  =  string
    aws_role  =  string
    ns_role   =  string
  }))
}

variable "additional_iam_roles" {
  type = list(object({
    rolearn  =  string
    username =  string
    groups   =  list(string)
  }))
}

variable "add_role_to_namespace"{
  type = list(object({
    namespace_name  =  string
    aws_role  =  string
    ns_role   =  string
  }))
}

variable "configure_gitops" {
  type        = bool
}

variable "configure_kubewatch" {
  type        = bool
}

variable "cluster_admin_access" {
  type = list(object({
    rolearn  =  string
    username =  string
    groups   =  list(string)
  }))
}

variable "namespaces_quota" {
  type = list(object({
    namespace_name  =  string
    cpu        =  number
    memory     =  string
  }))
}

variable "configure_additional_subnet" {
  type        = bool
  # default     = false
}

variable "additional_subnets_cidr_block" {
  type        = list(string)
  description = "Additional Subnet CIDR block."
  # default     = []
}

variable "whitelisted_ips" {
  type        = list(string)
  description = "Ips to whitelist"
  # default     = []
}

variable "is_existing_subnet" {
  type        = bool
  description = "store value whether to provision subnet for nat gw and endpoint cluster deployment"
}

variable "configure_efs" {
  type        = bool
}

variable "efs_ids" {
  type        = string
  description = "EFS Volume Ids."
}

variable "Harbor_creds" {
  type = object({
    password =  string
    username =  string
  })
}

variable "sourceAccountId" {
  type        = string
  description = "Source Account ID"
}

variable "trendMicroTenantId" {
  type        = string
  description = "Tenant ID based on tenant name for trendmicro registration"
}

# variable "aws_vpc_cni" {
#   description = "Installs the AWS CNI Daemonset"
#   type = object({
#     version    = string
#     extra_sets = map(string)
#   })
#   default = {
#     version    = "1.1.2"
#     extra_sets = {
#       "init.image.tag" : "v1.7.5"
#       "image.tag" : "v1.7.5"
#       "env.AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG" : "true"
#       "env.ENI_CONFIG_LABEL_DEF" : "failure-domain.beta.kubernetes.io/zone"
#     }
#   }
# }