#!/bin/bash

terraform init -no-color 
terraform $TF_ACTION -no-color
if [ "$TF_ACTION" = "destroy -auto-approve" ] ; 
then
sleep 10
terraform $TF_ACTION -no-color
fi
echo "++++++++++++++++++++++++++++++++++ Terraform State Start here++++++++++++++++++++++++++++++++"
terraform state list || true
echo "++++++++++++++++++++++++++++++++++ Terraform State Ends here++++++++++++++++++++++++++++++++"