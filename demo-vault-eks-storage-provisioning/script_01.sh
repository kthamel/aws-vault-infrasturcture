#!/bin/bash 
echo "*********** Required EBS Volume ID are as follows: ***********"
export Volume_ID=$(aws ec2 describe-volumes --filters "Name=tag:Name,Values=Vault_Storage_backend"| awk '/"VolumeId":/{print $NF}' | cut -d\" -f2)

echo "*********** Exported value is: $Volume_ID ***********"

echo "*********** Creating the Persistant Volume ***********"
kubectl create -f tech-01/create_pv.yaml

echo "*********** Creating the Persistant Volume Claim ***********"
kubectl create -f tech-01/create_pvc.yaml