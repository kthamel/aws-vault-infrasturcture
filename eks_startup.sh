#!/bin/bash 
echo "*********** Provisioning the AWS Vault Infrastructure ***********"
MWDIR=$(PWD)
echo $MWDIR

## Terraform Initialization ##
cd $MWDIR/demo-vault-eks-infrastructure
echo "*********** Initialize the directory ***********"
terraform init

## Terraform Formatting ##
cd $MWDIR/demo-vault-eks-infrastructure
echo "*********** Canonical Formatting of Codes ***********"
terraform fmt .

## Terraform Validation ##
cd $MWDIR/demo-vault-eks-infrastructure
echo "*********** Validate the Terraform Configurations ***********"
terraform validate

## Terraform Planning ##
cd $MWDIR/demo-vault-eks-infrastructure
echo "*********** Terraform Plan Output ***********"
terraform plan

## Terraform Apply ##
cd $MWDIR/demo-vault-eks-infrastructure
echo "*********** Terraform Applying ***********"
terraform apply --auto-approve

## Authenticate to the Kubernetes Cluster ##
cd $MWDIR/demo-kubernetes-deployment
echo "*********** Authenticating to the Kubernetes Cluster ***********"
aws eks list-clusters
aws eks update-kubeconfig --region us-east-1 --name kthamel-eks-cluster

## Create EBS Volume ##
cd $MWDIR/demo-vault-eks-storage-provisioning
echo "*********** Creating the EBS Volume ***********"
terraform apply --auto-approve

# ## Creating Storage Class ##
# cd $MWDIR/demo-vault-eks-storage-provisioning
# echo "*********** Creating the Persistant Volume ***********"
# kubectl create -f create-sc.yaml

## Creating the EBS CSI Driver ##
echo "*********** Creating the EBS CSI Drive Add-on ***********"
aws eks create-addon --cluster-name kthamel-eks-cluster --addon-name aws-ebs-csi-driver \
  --service-account-role-arn arn:aws:iam::533629863969:role/AmazonEKS_EBS_CSI_DriverRole

## Annotating the EBS CSI Driver ##
kubectl annotate serviceaccount ebs-csi-controller-sa \
    -n kube-system \
    eks.amazonaws.com/role-arn=arn:aws:iam::533629863969:role/AmazonEKS_EBS_CSI_DriverRole

## Create Persistent Volume and Volume Claim ##
cd $MWDIR/demo-vault-eks-storage-provisioning
echo "*********** Creating the Persistent Volume and the Volume Claim ***********"
bash script_01.sh

## Creating the Persistant Volume ##
cd $MWDIR/demo-vault-eks-storage-provisioning
echo "*********** Creating the Persistant Volume Claim ***********"
kubectl create -f create-pvc.yaml

## List Available Persistant Volumes ##
echo "*********** List the Provisioned Persistant Volumes ***********"
kubectl get pvc

# ## Deploy Vault Helm Chart ##
# cd $MWDIR/demo-kubernetes-deployment
# echo "*********** Deploying Hashicorp Vault using Helm Charts ***********"
# bash script_01.sh
