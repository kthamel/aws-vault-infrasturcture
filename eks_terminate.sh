#!/bin/bash 
echo "*********** Destroying the AWS Vault Infrastructure ***********"
MWDIR=$(PWD)
echo $MWDIR

## Terraform Initialization ##
cd $MWDIR/demo-vault-eks-infrastructure
echo "*********** Initialize the directory ***********"
terraform init

## Terraform Apply for Destroying ##
cd $MWDIR/demo-vault-eks-infrastructure
echo "*********** Terraform Applying ***********"
terraform destroy --auto-approve

## Destroy EBS Volume ##
cd $MWDIR/demo-vault-eks-storage-provisioning
echo "*********** Destroying the EBS Volume ***********"
terraform destroy --auto-approve