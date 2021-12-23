#!/bin/bash

export TF_VAR_Harbor_creds=`echo "${TF_HarborCreds//[:]/=}"`
echo $TF_VAR_Harbor_creds

cat ./post-cluster-components.tf
echo "terraform execution starts"

#export TF_LOG=DEBUG

terraform init -no-color -lock=false
terraform $TF_ACTION -no-color -lock=false
if [ "$TF_ACTION" = "destroy -auto-approve" ] ; 
then
sleep 10
terraform $TF_ACTION -no-color
fi
echo "++++++++++++++++++++++++++++++++++ Terraform State Start here++++++++++++++++++++++++++++++++"
terraform state list || true
echo "++++++++++++++++++++++++++++++++++ Terraform State Ends here++++++++++++++++++++++++++++++++"
