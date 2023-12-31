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

# ## Deploy Vault Helm Chart ##
# cd $MWDIR/demo-kubernetes-deployment
# echo "*********** Deploying Hashicorp Vault using Helm Charts ***********"
# bash script_01.sh
