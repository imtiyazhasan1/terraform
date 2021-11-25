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

service qualys-cloud-agent stop
/usr/local/qualys/cloud-agent/bin/qualys-cloud-agent.sh ActivationId=6f5d2eec-ba86-443c-88af-07a394fc3148 CustomerId=3f751192-e92e-d42e-83ce-c5a54f519118

/opt/ds_agent/dsa_control -r
/opt/ds_agent/dsa_control -a dsm://trend-dsm.aws-shared.vodafone.com:4120/ "tenantId:tenantNameValue"
		
/etc/eks/bootstrap.sh ${ClusterName} --b64-cluster-ca ${ClusterCA} --apiserver-endpoint ${ClusterAPIEndpoint}  --kubelet-extra-args "--node-labels=workergroup=${ClusterName}-worker"

systemctl daemon-reload
systemctl restart docker

--==MYBOUNDARY==--