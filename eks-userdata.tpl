MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="==MYBOUNDARY=="

--==MYBOUNDARY==
Content-Type: text/x-shellscript; charset="us-ascii"

#!/bin/bash

set -o xtrace

yum install -y amazon-efs-utils
yum install -y amazon-ssm-agent 
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent
systemctl status amazon-ssm-agent

/etc/eks/bootstrap.sh ${ClusterName} --b64-cluster-ca ${ClusterCA} --apiserver-endpoint ${ClusterAPIEndpoint}  --kubelet-extra-args "--node-labels=workergroup=${ClusterName}-worker"

systemctl daemon-reload
systemctl restart docker

--==MYBOUNDARY==--