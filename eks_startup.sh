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

## Create Persistent Volume and Volume Claim ##
cd $MWDIR/demo-vault-eks-storage-provisioning
echo "*********** Creating the Persistent Volume and the Volume Claim ***********"
bash script_01.sh


##  List Available Persistant Volumes ##
echo "*********** List the Provisioned Persistant Volumes ***********"
kubectl get pv
