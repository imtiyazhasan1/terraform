# terraform.tf : Location of the terraform state file . kms_key_id is common per project, (s3)key is unique to each code pipeline

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "gks-cluster-provisioner-tf-remote-state-prod"           # replace with remote_state_bucket name
    dynamodb_table = "gks-cluster-provisioner-tf-locks-prod"                  # replace with tf_locks_table name
    region         = "eu-central-1"                                  # replace with deployment region
    key            = "cluster_name/terraform.tfstate" # replace with name of the repo which will define resources
    kms_key_id     = "arn:aws:kms:eu-central-1:031555447040:key/a1b856ec-56f0-46be-a4ca-09db57c6439f"
  }
}
