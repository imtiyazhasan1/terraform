#region = "eu-central-1"

#az_1 = "eu-central-1a"
#az_2 = "eu-central-1b"

#NameTag = "MEINDSL"
#ENV     = "PRD"

#vpc_cidr_block = "10.1.0.0/16"

#aws1_cidr_block = "10.1.1.0/24"
#aws2_cidr_block = "10.1.2.0/24"

#private1_app1_cidr_block = "10.1.3.0/24"
#private2_app1_cidr_block = "10.1.4.0/24"

#private1_app2_cidr_block = "10.1.5.0/24"
#private2_app2_cidr_block = "10.1.6.0/24"

#data1_cidr_block = "10.1.7.0/24"
#data2_cidr_block = "10.1.8.0/24"



#meindsl_as_min        = "1"
#meindsl_as_max        = "1"
#meindsl_as_desired    = "1"
#meindsl_instance_type = "t2.micro"

#vfksc_as_min        = "1"
#vfksc_as_max        = "1"
#vfksc_as_desired    = "1"
#vfksc_instance_type = "t2.micro"


############# Its for MeinDSL private vpc and eks cluster ###################################

#vpc_name           = "MeinDSL-vpc"
#count_subnet       = 3
#eks_cidr_block     = "10.99.0.0/16"
#cluster_name       = "test-cluster-abc"
#kubernetes_version = 1.16
#######ami = "if you want to override the defult one please change this one"
#instance_type             = "t2.large"
#desired_capacity          = 2
#max_size                  = 6
#min_size                  = 2
#enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager"]
