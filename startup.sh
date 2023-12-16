#!/bin/bash 
echo "Provisioning the AWS Vault Infrastructure"
MWDIR=$(PWD)
echo $MWDIR

## Terraform Initialization ##
cd $MWDIR/demo-aws-infrastructure
echo "Initialize the directory"
terraform init

## Terraform Formatting ##
cd $MWDIR/demo-aws-infrastructure
echo "Canonical Formatting of Codes"
terraform fmt .

## Terraform Validation ##
cd $MWDIR/demo-aws-infrastructure
echo "Validate the Terraform Configurations"
terraform init

## Terraform Planning ##
cd $MWDIR/demo-aws-infrastructure
echo "Terraform Plan Output"
terraform plan
