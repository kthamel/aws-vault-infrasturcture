#!/bin/bash
echo "Creating the EBS CSI Driver Policy"
aws iam create-role \
  --role-name AmazonEKS_EBS_CSI_DriverRole \
  --assume-role-policy-document file://"ebs-csi-driver-policy.json"

echo "Attaching the Policy to Role"
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --role-name AmazonEKS_EBS_CSI_DriverRole
