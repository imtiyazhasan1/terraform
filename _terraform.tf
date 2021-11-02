# terraform.tf : Location of the terraform state file . kms_key_id is common per project, (s3)key is unique to each code pipeline

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "tf_s3_bucket"                     # replace with remote_state_bucket name
    dynamodb_table = "tf_dynamodb_table"                # replace with tf_locks_table name
    region         = "tf_region"                   # replace with deployment region
    key            = "cluster_name/terraform.tfstate" # replace with name of the repo which will define resources
    kms_key_id     = "tf_kms_key_arn"
  }
}
