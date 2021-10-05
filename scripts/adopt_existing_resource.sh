#!/usr/bin/env bash

set -euo pipefail

aws eks update-kubeconfig --name $TF_VAR_cluster_name --region $TF_VAR_region
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl

# don't import the crd. Helm cant manage the lifecycle of it anyway.
for kind in daemonSet clusterRole clusterRoleBinding serviceAccount; do
  echo "setting annotations and labels on $kind/aws-node"
  ./kubectl -n kube-system annotate --overwrite $kind aws-node meta.helm.sh/release-name=aws-vpc-cni
  ./kubectl -n kube-system annotate --overwrite $kind aws-node meta.helm.sh/release-namespace=kube-system
  ./kubectl -n kube-system label --overwrite $kind aws-node app.kubernetes.io/managed-by=Helm
done
