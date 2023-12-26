#!/bin/bash 
echo "*********** Destroying the AWS Vault Infrastructure ***********"
MWDIR=$(PWD)
echo $MWDIR

## Terraform Apply for Destroying ##
cd $MWDIR/demo-vault-eks-infrastructure
echo "*********** Terraform Applying ***********"
terraform destroy --auto-approve
