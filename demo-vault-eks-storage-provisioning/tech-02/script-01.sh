#!/bin/bash

echo "*********** Fetch the OIDC Provider URL ***********"
aws eks describe-cluster --name kthamel-eks-cluster --query "cluster.identity.oidc.issuer" --output text

echo "*********** Export the Identity as Environment Variable ***********"
export OIDC_URL=$(aws eks describe-cluster --name kthamel-eks-cluster --query "cluster.identity.oidc.issuer" --output text)
echo Exporting ...
export OIDC_ID=${OIDC_URL##*/}

echo "*********** Exported OIDC_ID Value is: ***********"
echo $OIDC_ID

echo "*********** Re-Writing the ebs-csi-policy.json Using New OIDC_ID Value ***********"
tee new-ebs-csi-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Federated": "arn:aws:iam::533629863969:oidc-provider/oidc.eks.region-code.amazonaws.com/id/$OIDC_ID"
        },
        "Action": "sts:AssumeRoleWithWebIdentity",
        "Condition": {
          "StringEquals": {
            "oidc.eks.region-code.amazonaws.com/id/$OIDC_ID:aud": "sts.amazonaws.com",
            "oidc.eks.region-code.amazonaws.com/id/$OIDC_ID:sub": "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  }
EOF

echo "*********** Create the EBS CSI Driver Role ***********"
aws iam create-role \
  --role-name AmazonEKS_EBS_CSI_DriverRole \
  --assume-role-policy-document file://"new-ebs-csi-policy.json"

echo "*********** Attach the Policy into the New EBS CSI Driver Role ***********"
aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --role-name AmazonEKS_EBS_CSI_DriverRole
